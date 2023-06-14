local ok = import 'kubernetes/outreach.libsonnet';
local app = (import 'kubernetes/app.libsonnet').info('vivekshahintro');

local all = {
  // tollgate_configmap is the ConfigMap used to set the RPS rate limits on
  // partitions for this application's gRPC server. Look in your override
  // jsonnet manifest for the variable that the data of this configmap gets
  // populated using.
  tollgate_configmap: ok.ConfigMap('tollgate-%s' % app.name, app.namespace) {
    local this = self,
    metadata+: {
      labels+: {
        'tollgate.outreach.io/scrape': 'true',
      },
      annotations+: {
        'tollgate.outreach.io/group': app.name,
      },
    },
    // This key is set in the override jsonnet manifest.
    data_:: {},
    data: {
      'tollgate.yaml': std.manifestYamlDoc(this.data_),
    },
  },
};

all
