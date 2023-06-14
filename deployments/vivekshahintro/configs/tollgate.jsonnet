// Copyright 2023 Outreach Corporation. All Rights Reserved.
//
// Description: This file contains the configuration for tollgate
// Managed: true

local app = (import 'kubernetes/app.libsonnet').info('vivekshahintro');

// tollgateRateLimits are the partitions and their maximum RPS before
// rate limiting starts occurring for your RPCs. For more information
// on the syntax here, see https://github.com/getoutreach/tollmon#config-map
local tollgateRateLimits = {
  // This partition effectively says to rate limit any org when their RPS
  // is greater than or equal to 1000. This is because each org will render
  // a partition that looks like org=<guid>, so this partition will prefix
  // match on all of them.
  'org=': 1000,
  // <<Stencil::Block(tollgateRateLimits)>>

  // <</Stencil::Block>>
};

{
  default: {
    tollgate_configmap+: {
      data_+:: tollgateRateLimits,
    },
  },
}
