local argo = import 'kubernetes/argo.libsonnet';
local ok = import 'kubernetes/outreach.libsonnet';
local app = (import 'kubernetes/app.libsonnet').info('vivekshahintro');

local version = std.extVar('version_%s' % app.name);

// <<Stencil::Block(extraJsonnetImports)>>

// <</Stencil::Block>>

local all() = {
  app: argo.ArgoCDApplication(app, 'stencil-pipeline') {
    version_:: version,
    env_:: {
      // <<Stencil::Block(extraEnvironmentVariables)>>

      // <</Stencil::Block>>
    },
  },
};

ok.List() { items_+: all() }
