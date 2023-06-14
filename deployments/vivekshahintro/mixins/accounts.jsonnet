local app = (import 'kubernetes/app.libsonnet').info('vivekshahintro');

local isDev = app.environment == 'development' || app.environment == 'local_development';
local isStaging = app.environment == 'staging';

local accountsHost = if isDev then
  'accounts.outreach-dev.com'
else if isStaging then
  'accounts.outreach-staging.com'
else
  'accounts.outreach.io';

local accountsInternalHost = if isDev then
  'outreach-accounts.outreach-accounts'
else
  accountsHost;

local baseURL = if isDev then
  'http://%s' % accountsHost
else
  'https://%s' % accountsHost;

local all = {
  deployment+: {
    spec+: {
      template+: {
        spec+: {
          containers_+:: {
            default+: {
              env_+:: {
                OUTREACH_ACCOUNTS_BASE_URL: baseURL,
              },
            },
          },
        },
      },
    },
  },
};

all
