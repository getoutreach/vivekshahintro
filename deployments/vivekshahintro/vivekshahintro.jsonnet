// Copyright 2023 Outreach Corporation. All Rights Reserved.
//
// Managed: true

local segments = import '../../concourse/segments.libsonnet';
local ok = import 'kubernetes/outreach.libsonnet';
local app = (import 'kubernetes/app.libsonnet').info('vivekshahintro');
local resources = import './resources.libsonnet';
local argo = import 'kubernetes/argo.libsonnet';
local appImageRegistry = std.extVar('appImageRegistry');
local devEmail = std.extVar('dev_email');
local isDev = app.environment == 'development' || app.environment == 'local_development';

local sharedLabels = {
  repo: app.name,
  bento: app.bento,
  reporting_team: 'ce-success-plans-services',
};

local all = {
  namespace: ok.Namespace(app.namespace) {
    metadata+: {
      annotations+: {
        'iam.amazonaws.com/permitted': '%s_service_role' % app.name,
      },
      labels+: sharedLabels,
    },
  },
  service: ok.Service(app.name, app.namespace) {
    target_pod:: $.deployment.spec.template,
    metadata+: {
      labels+: sharedLabels,
    },
    spec+: {
      local this = self,
      sessionAffinity: 'None',
      type: 'ClusterIP',
      ports_:: {
        grpc: {
          port: 5000,
          targetPort: 'grpc',
        },
        metrics: {
          port: 8000,
          targetPort: 'http-prom',
        },
      },
      ports: ok.mapToNamedList(this.ports_),
    },
  },
  pdb: ok.PodDisruptionBudget(app.name, app.namespace) {
    metadata+: {
      labels: sharedLabels,
    },
    spec+: { maxUnavailable: 1 },
  },
  // Default configuration for the service, managed by stencil.
  // all other configuration should be done in the
  // vivekshahintro.config.jsonnet file
  configmap: ok.ConfigMap('config', app.namespace) {
    metadata+: {
      annotations+: {
        // deploy configmap after vault-secret-operator CRD (sync wave-value of -5)
        'argocd.argoproj.io/sync-wave': '-4',
      },
    },
    local this = self,
    data_:: {},
    data: {
      // We use this.data_ to allow for ez merging in the override.
      ['%s.yaml' % app.name]: std.manifestYamlDoc(this.data_),
    },
  },
  trace_configmap: ok.ConfigMap('config-trace', app.namespace) {
    local this = self,
    data_:: {
      OpenTelemetry: {
        Enabled: true,
        CollectorEndpoint: 'otel-collector-tracing.monitoring.svc.cluster.local:4317',
        Endpoint: 'api.honeycomb.io',
        APIKey: {
          Path: '/run/secrets/outreach.io/honeycomb/apiKey',
        },
        Dataset: if isDev then 'dev' else 'outreach',
        SamplePercent: if isDev then 100 else 0.25,
      },
    } + if isDev then {
      GlobalTags+: {
        DevEmail: devEmail,
      },
    } else {},
    data: {
      // We use this.data_ to allow for ez merging in the override.
      'trace.yaml': std.manifestYamlDoc(this.data_),
    },
  },
  fflags_configmap: ok.ConfigMap('fflags-yaml', app.namespace) {
    local this = self,
    data_:: {
      apiKey: {
        Path: '/run/secrets/outreach.io/launchdarkly/sdk-key',
      },
      flagsToAdd: {
        bento: app.bento,
        channel: if isDev then 'dev' else app.channel,
      } + if isDev then {
        dev_email: devEmail,
      } else {},
    },
    data: {
      // We use this.data_ to allow for ez merging in the override.
      'fflags.yaml': std.manifestYamlDoc(this.data_),
    },
  },

  deployment: ok.Deployment(app.name, app.namespace) {
    local deployment_volume_mounts = {
      // default configuration files
      ['config-%s' % app.name]: {
        mountPath: '/run/config/outreach.io/%s.yaml' % app.name,
        subPath: '%s.yaml' % app.name,
      },
      'config-trace-volume': {
        mountPath: '/run/config/outreach.io/trace.yaml',
        subPath: 'trace.yaml',
      },
      'fflags-yaml-volume': {
        mountPath: '/run/config/outreach.io/fflags.yaml',
        subPath: 'fflags.yaml',
      },
      // user provided secrets
    },
    metadata+: {
      labels+: sharedLabels,
    },
    spec+: {
      replicas: if isDev then 1 else 2,
      template+: {
        metadata+: {
          labels+: sharedLabels {
            'tollgate.outreach.io/scrape': 'true',
          },
          annotations+: {
            'tollgate.outreach.io/group': app.name,
            'tollgate.outreach.io/port': '5000',
            'iam.amazonaws.com/role': '%s_service_role' % app.name,
            datadog_prom_instances_:: [
              {
                prometheus_url: 'http://%%host%%:' +
                                $.deployment.spec.template.spec.containers_.default.ports_['http-prom'].containerPort +
                                '/metrics',
                namespace: app.name,
                metrics: ['*'],
                send_distribution_buckets: true,
              },
            ],
            // https://docs.datadoghq.com/integrations/openmetrics/
            ['ad.datadoghq.com/' + app.name + '.check_names']: '["openmetrics"]',
            ['ad.datadoghq.com/' + app.name + '.init_configs']: '[{}]',
            ['ad.datadoghq.com/' + app.name + '.instances']: std.manifestJsonEx(self.datadog_prom_instances_, '  '),
          },
        },
        spec+: {
          priorityClassName: 'high-priority',
          containers_:: {
            default: ok.Container(app.name) {
              image: '%s/%s:%s' % [appImageRegistry, app.name, app.version],
              imagePullPolicy: 'IfNotPresent',
              volumeMounts_+:: deployment_volume_mounts,
              env_+:: {
                MY_POD_SERVICE_ACCOUNT: ok.FieldRef('spec.serviceAccountName'),
                MY_NAMESPACE: ok.FieldRef('metadata.namespace'),
                MY_POD_NAME: ok.FieldRef('metadata.name'),
                MY_NODE_NAME: ok.FieldRef('spec.nodeName'),
                MY_DEPLOYMENT: app.name,
                MY_ENVIRONMENT: app.environment,
                MY_CLUSTER: app.cluster,
                MY_REGION: app.region,
              },
              readinessProbe: {
                httpGet: {
                  path: '/healthz/ready',
                  port: 'http-prom',
                },
                initialDelaySeconds: 5,
                timeoutSeconds: 1,
                periodSeconds: 15,
              },
              livenessProbe: self.readinessProbe {
                initialDelaySeconds: 15,
                httpGet+: {
                  path: '/healthz/live',
                },
              },
              ports_+:: {
                grpc: { containerPort: 5000 },
                'http-prom': { containerPort: 8000 },
              },
              resources: resources,
            },
          },
          volumes_+:: {
            // default configs
            ['config-%s' % app.name]: ok.ConfigMapVolume(ok.ConfigMap('config', app.namespace)),
            'config-trace-volume': ok.ConfigMapVolume(ok.ConfigMap('config-trace', app.namespace)),
            'fflags-yaml-volume': ok.ConfigMapVolume(ok.ConfigMap('fflags-yaml', app.namespace)),

            // user provided secrets
          },
        },
      },
    },
  },
};

// vaultOperatorSecrets stores vault secrets for production environments
// this is not related to the development vault secrets operator
local vaultOperatorSecrets = {
};

// These secrets will be included in dev by default, they are fetched from vault.
local developmentObjects = {

  service+: {
    metadata+: {
      annotations+: {
        // Allow everyone AdminGW gRPCUI access in dev environment
        'outreach.io/admingw-allow-grpc-1000000': '.* Everyone',
      },
    },
  },
};

local override = import './vivekshahintro.override.jsonnet';
local configuration = import './vivekshahintro.config.jsonnet';

local mixins = [
  import './mixins/accounts.jsonnet',
  import './mixins/devenv.jsonnet',
  import './mixins/mint.jsonnet',
  import './mixins/tollgate.jsonnet',
];
local mergedMixins = std.foldl(function(x, y) (x + y), mixins, {});

ok.FilteredList() {
  // Note: configuration overrides the <appName>.override.jsonnet file,
  // which then overrides the objects found in this file.
  // This is done via a simple key merge, and jsonnet object '+:' notation.
  items_+:: all + (if isDev then developmentObjects else if app.clusterType == 'legacy' then {} else vaultOperatorSecrets)
            + mergedMixins
            + override
            + configuration,
}
