local ok = import 'kubernetes/outreach.libsonnet';
local app = (import 'kubernetes/app.libsonnet').info('vivekshahintro');
local appImageRegistry = std.extVar('appImageRegistry');
local smartstore = import 'smartstore.libsonnet';
local pgvolumes = import './postgresql.volumes.jsonnet';
local name = '%s-migrations' % app.name;

local migrations = {
  migrations: ok.Job(name, app=app.name, namespace=app.namespace) {
    metadata+: {
      annotations+: {
        'argocd.argoproj.io/hook': 'Sync',
        'argocd.argoproj.io/sync-wave': '-3',
        'argocd.argoproj.io/hook-delete-policy': 'BeforeHookCreation',
      },
    },
    spec+: {
      backoffLimit: 1,
      completions: 1,
      parallelism: 1,
      ttlSecondsAfterFinished: 3600,
      template+: {
        metadata+: {
          labels+: smartstore.SharedLabels { app: app.name + '-migrations' },
          annotations: {
            'cluster-autoscaler.kubernetes.io/safe-to-evict': 'false',
          },
        },
        spec+: {
          restartPolicy: 'Never',
          serviceAccountName: $.svc_acct.metadata.name,
          containers_:: {
            default: ok.Container(name) {
              image: '%s/%s:%s' % [appImageRegistry, app.name, app.version],
              command: [
                '/usr/local/bin/vivekshahintro-migrations',
                'vivekshahintro',
              ],
              resources: {
                limits: {
                  cpu: '1000m',
                  memory: '4Gi',
                },
                requests: {
                  cpu: '1000m',
                  memory: '256Mi',
                },
              },
              env_+:: {
                MY_POD_SERVICE_ACCOUNT: ok.FieldRef('spec.serviceAccountName'),
                MY_NAMESPACE: ok.FieldRef('metadata.namespace'),
                MY_POD_NAME: ok.FieldRef('metadata.name'),
                MY_NODE_NAME: ok.FieldRef('spec.nodeName'),
                MY_DEPLOYMENT: app.name,
                MY_ENVIRONMENT: app.environment,
                MY_CLUSTER: app.cluster,
              },
              volumeMounts_+:: pgvolumes.default_volume_mounts + pgvolumes.postgresql_volume_mounts,
            },
          },
          volumes_+:: pgvolumes.default_volumes + pgvolumes.postgresql_volumes,
        },
      },
    },
  },
};

migrations
