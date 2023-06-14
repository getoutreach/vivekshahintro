// Copyright 2023 Outreach Corporation. All Rights Reserved.

// Description: This file is only necessary to render the godoc for the package. See the package
// comment for more details on what this package is used for at-large.
// Managed: true

// Package lifecycle contains handlers for various stages in the lifecycle of entities at Outreach.
// These handlers are conditionally rendered based off of what is found underneath the `entities`
// argument within a stencil project's service.yaml.
//
// These handlers can be used to perform specific actions once a lifecycle event is triggered for
// a specific entity. An example of this would be to delete any data you've stored on behalf of an
// org whenever an org churn lifecycle event is invoked.
package lifecycle
