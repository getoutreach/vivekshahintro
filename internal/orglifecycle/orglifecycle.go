// Copyright 2023 Outreach Corporation. All Rights Reserved.

// Description: This file is only around until we issue a breaking change to move the exposed
// directive to the new location (internal/lifecycle/org.go).
// Managed: true

// Package orglifecycle contains a singleton to register org lifecycle hooks onto that get
// invoked by orgservice whenever a relevant org event occurs.
package orglifecycle

import (
	"time"

	orglifeapi "github.com/getoutreach/orgservice/api"
	"github.com/getoutreach/orgservice/pkg/lifecycle"
	// <<Stencil::Block(orgLifecycleImports)>>
	// <</Stencil::Block>>
)

// Default is a singleton used to register org lifecycle hooks that are invoked synchronously via
// this service's gRPC server. The necessary gRPC service and associated RPCs are registered
// onto this service's gRPC server by way of the OrgService function found within this file.
//
// To register a hook to run on org creation, use `Default.RegisterOrgCreator`. Likewise, to
// register a hook to run on org churn, use `Default.RegisterOrgDeleter`.
var Default = func() lifecycle.Lifecycle {
	// l holds the Lifecyle instance which is mutated throughout this
	// method and returned at the end
	var l = lifecycle.Lifecycle{
		ChurnRegistration: &orglifeapi.RegisterLifecycleConsumerRequest{
			Name:        "vivekshahintro",
			RequestType: orglifeapi.RegisterLifecycleConsumerRequest_CHURN,
			// IsRequired: When true, results in orgservice sending a P2 page configured by
			// NotifyFailureAfterSecs on failure for Churn
			IsRequired:             true,
			NotifyFailureAfterSecs: uint32((time.Hour * 24).Seconds()),
		},

		// <<Stencil::Block(orgLifecycleOpts)>>

		// <</Stencil::Block>>
	}

	// <<Stencil::Block(orgLifecycleDefaults)>>
	// Modify the defaults from the lifecycle struct here
	// <</Stencil::Block>>

	return l
}()
