// Code managed by stencil, DO NOT MODIFY
// MODIFY THE vivekshahintro.override.jsonnet INSTEAD
// This file is used to add mint support to your application.
local ok = import 'kubernetes/outreach.libsonnet';
local app = (import 'kubernetes/app.libsonnet').info('vivekshahintro');
local resources = import './resources.libsonnet';

local isDev = app.environment == 'development' || app.environment == 'local_development';

local all = {
  svc_acct: ok.ServiceAccount('%s-svc' % app.name, app.namespace) {
    metadata+: {
      annotations+: {
        'outreach.io/authn-v1-service-id': 'vivekshahintro@outreach.cloud',
        'outreach.io/authn-v1-alias-ids': 'platform-services@outreach.cloud',
        'outreach.io/authn-v1-audience-ids': 'orgservice@outreach.cloud tollmon@outreach.cloud',
        'outreach.io/authn-v1-can-impersonate-user': 'false',
        'outreach.io/authn-v1-permitted-user-scopes': '',
        'outreach.io/authn-v1-sa-audience-ids': '',
        'outreach.io/authn-v1-sa-obj-types': '',
        'outreach.io/authn-v1-sa-gov-ids': '',
      },
    },
  },
  // Grant this service account permission to issue tokens that vouch for
  // its identity to other services.
  service_token_issue_role: ok.Role(app.name + '-service-token-role', app=app.name, namespace=app.namespace) {
    rules: [
      {
        apiGroups: [''],
        resources: ['serviceaccounts/token'],
        verbs: ['create'],
        resourceNames: [$.svc_acct.metadata.name],
      },
      {
        apiGroups: [''],
        resources: ['serviceaccounts'],
        verbs: ['get'],
        resourceNames: [$.svc_acct.metadata.name],
      },
    ],
  },
  service_token_issue_role_binding: ok.RoleBinding(app.name, app=app.name, namespace=app.namespace) {
    subjects_: [$.svc_acct],
    roleRef_: $.service_token_issue_role,
  },

  deployment+: {
    spec+: {
      template+: {
        spec+: {
          serviceAccountName: $.svc_acct.metadata.name,
          containers_+:: {
            default+: {
              volumeMounts_+:: {
                'config-authn-mint-volume': {
                  mountPath: '/run/config/outreach.io/authn_mint.yaml',
                  subPath: 'authn_mint.yaml',
                },
                'config-authn-flagship-volume': {
                  mountPath: '/run/config/outreach.io/authn_flagship.yaml',
                  subPath: 'authn_flagship.yaml',
                },
              },
            },
          },
          volumes_+:: {
            'config-authn-mint-volume': ok.ConfigMapVolume(ok.ConfigMap('config-authn-mint', app.namespace)),
            'config-authn-flagship-volume': ok.ConfigMapVolume(ok.ConfigMap('config-authn-flagship', app.namespace)),
          },
        },
      },
    },
  },

  // We pull in all the public keys for this environment.
  // The app will choose which of these to consider trustworthy.
  authn_mint_configmap: ok.ConfigMap('config-authn-mint', app.namespace) {
    local this = self,
    data_:: {
      Path: '/run/secrets/outreach.io/mint-validator-payload/validation_keys_jwks',
    },
    data: {
      'authn_mint.yaml': std.manifestYamlDoc(this.data_),
    },
  },
  authn_flagship_configmap: ok.ConfigMap('config-authn-flagship', app.namespace) {
    local this = self,
    data_:: {
      Path: '/run/secrets/outreach.io/authn-flagship-payload/internal_secret',
    },
    data: {
      'authn_flagship.yaml': std.manifestYamlDoc(this.data_),
    },
  },
};

local developmentResources = {
  service+: {
    metadata+: {
      annotations+: {
        // Allow everyone AdminGW gRPCUI access in dev environment
        'outreach.io/admingw-allow-grpc-1000000': '.* Everyone',
      },
    },
  },

  // This service accounts is used in e2e tests and is otherwise harmless.
  // It is configured with the permissions it will need to take on any user
  // identity and any scopes required to execute the tests.  It also has
  // permission to send requests to the service under test, of course.
  e2e_svc_account: ok.ServiceAccount('%s-e2e-client-svc' % app.name, app.namespace) {
    metadata+: {
      annotations+: {
        'outreach.io/authn-v1-service-id': '%s-e2e-client@outreach.cloud' % app.name,
        'outreach.io/authn-v1-audience-ids': 'orgservice@outreach.cloud tollmon@outreach.cloud vivekshahintro@outreach.cloud flagship@outreach.cloud flagship-internal@outreach.cloud',
        'outreach.io/authn-v1-can-impersonate-user': 'true',
        'outreach.io/authn-v1-permitted-user-scopes': 'AAA=',
        'outreach.io/authn-v1-sa-audience-ids': '',
        'outreach.io/authn-v1-sa-obj-types': '',
        'outreach.io/authn-v1-sa-gov-ids': '',
      },
    },
  },
  // Grant this service account permission to issue tokens that vouch for
  // its identity to other services.
  e2e_svc_token_issue_role: ok.Role(app.name + '-e2e-service-token-role', app=app.name, namespace=app.namespace) {
    rules: [
      {
        apiGroups: [''],
        resources: ['serviceaccounts/token'],
        verbs: ['create'],
        resourceNames: [$.e2e_svc_account.metadata.name],
      },
      {
        apiGroups: [''],
        resources: ['serviceaccounts'],
        verbs: ['get'],
        resourceNames: [$.e2e_svc_account.metadata.name],
      },
    ],
  },
  e2e_svc_token_issue_role_binding: ok.RoleBinding(app.name + '-e2e-rb', app=app.name, namespace=app.namespace) {
    subjects_: [$.e2e_svc_account],
    roleRef_: $.e2e_svc_token_issue_role,
  },
};

all + (if isDev then developmentResources else {})
