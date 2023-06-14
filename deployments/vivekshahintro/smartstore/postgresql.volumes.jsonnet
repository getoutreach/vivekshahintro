local ok = import 'kubernetes/outreach.libsonnet';
local app = (import 'kubernetes/app.libsonnet').info('vivekshahintro');
local appImageRegistry = std.extVar('appImageRegistry');
local isDev = app.environment == 'development' || app.environment == 'local_development';
local devEmail = std.extVar('dev_email');

{
  smartstore_trace_configmap: ok.ConfigMap('smartstore-config-trace', app.namespace) {
    local this = self,
    data_:: {
      OpenTelemetry: {
        Enabled: true,
        Endpoint: 'api.honeycomb.io',
        CollectorEndpoint: 'otel-collector-tracing.monitoring.svc.cluster.local:4317',
        APIKey: {
          Path: '/run/secrets/outreach.io/honeycomb/apiKey',
        },
        Dataset: if isDev then 'dev' else 'outreach',
        SamplePercent: if isDev then 0.000001 else 0.001,
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
  postgresql_volume_mounts: {
    'config-pg-vivekshahintro': {
      mountPath: '/run/config/outreach.io/pg-vivekshahintro-config.yaml',
      subPath: 'pg-vivekshahintro-config.yaml',
    },
    'secret-pg-vivekshahintro-volume': {
      mountPath: '/run/secrets/outreach.io/pg-vivekshahintro-users',
    },
    'config-pg-vivekshahintro-schemas': {
      mountPath: '/run/config/outreach.io/pg-vivekshahintro-schemas.yaml',
      subPath: 'pg-vivekshahintro-schemas.yaml',
    },
  },
  postgresql_volumes: {
    'config-pg-vivekshahintro': ok.ConfigMapVolume(ok.ConfigMap('pg-vivekshahintro-cfg', app.namespace)),
    'secret-pg-vivekshahintro-volume': ok.SecretVolume(ok.Secret('pg-vivekshahintro-users', app.namespace)),
    'config-pg-vivekshahintro-schemas': ok.ConfigMapVolume(ok.ConfigMap('config-pg-vivekshahintro-schemas', app.namespace)),
  },
  default_volumes: {
    ['config-%s' % app.name]: ok.ConfigMapVolume(ok.ConfigMap('config', app.namespace)),
    'smartstore-config-trace-volume': ok.ConfigMapVolume($.smartstore_trace_configmap),
    'fflags-yaml-volume': ok.ConfigMapVolume(ok.ConfigMap('fflags-yaml', app.namespace)),
    // user provided secrets
    // mint
    'config-authn-mint-volume': ok.ConfigMapVolume(ok.ConfigMap('config-authn-mint', app.namespace)),
    'config-authn-flagship-volume': ok.ConfigMapVolume(ok.ConfigMap('config-authn-flagship', app.namespace)),
  },
  default_volume_mounts: {
    ['config-%s' % app.name]: {
      mountPath: '/run/config/outreach.io/%s.yaml' % app.name,
      subPath: '%s.yaml' % app.name,
    },
    'smartstore-config-trace-volume': {
      mountPath: '/run/config/outreach.io/trace.yaml',
      subPath: 'trace.yaml',
    },
    'fflags-yaml-volume': {
      mountPath: '/run/config/outreach.io/fflags.yaml',
      subPath: 'fflags.yaml',
    },
    'config-authn-mint-volume': {
      mountPath: '/run/config/outreach.io/authn_mint.yaml',
      subPath: 'authn_mint.yaml',
    },
    'config-authn-flagship-volume': {
      mountPath: '/run/config/outreach.io/authn_flagship.yaml',
      subPath: 'authn_flagship.yaml',
    },
    // user provided secrets
  },
}
