// Copyright 2023 Outreach Corporation. All Rights Reserved.

// Description: This file contains handlers for all of the org lifecycle handlers that were
// requested either explicitly or implicitly to be rendered based off of what was found in
// the `entities.org` key of this service's service.yaml
// Managed: true

package lifecycle

import (
	"context"

	"github.com/getoutreach/gobox/pkg/events"
	"github.com/getoutreach/gobox/pkg/log"

	"github.com/getoutreach/orgservice/pkg/lifecycle"
	"github.com/getoutreach/vivekshahintro/internal/orglifecycle"
	"google.golang.org/grpc"
)

// In the next breaking change release of stencil-outreach orglifecycle.Default will be moved
// here and renamed (possibly reworked entirely to better match the other entity lifecycle
// handlers).

// OrgService registers the org lifecycle service onto the given gRPC server. This service is
// invoked by orgservice when specific events on orgs happen. When it is invoked the handlers
// the handlers set on `orglifecycle.Default` are invoked automatically for an individual
// event, such as org creation.
func OrgService(server *grpc.Server) {
	hooks, err := lifecycle.InitializeHooksWithRetry(context.Background(), orglifecycle.Default)
	if err != nil || hooks == nil {
		// orgservice will lazy initialize the handlers when
		// encountered uninit'd hooks
		log.Warn(context.Background(), "Failed to initialize lifecycle hooks, proceeding uninitialized", events.NewErrorInfo(err))
	}
	lifecycle.New(hooks, lifecycle.WithLifecyleConfig(&orglifecycle.Default)).RegisterRPCs(server)
}
