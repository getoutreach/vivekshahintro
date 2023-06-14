// Copyright 2023 Outreach Corporation. All Rights Reserved.

// Description: This file contains the gRPC server implementation for the vivekshahintro
// API defined in api/vivekshahintro.proto. This implementation is used in the
// rpc.go when creating and exposing the gRPC server.

package vivekshahintro //nolint:revive // Why: We allow [-_].
import (
	"context"
	"fmt"
)

// Server is the actual server implementation of the API.
//
// Note that tracing, logging and metrics are already handled for these
// methods.
type Server struct {
	// Place any handler state for your service here.
}

// NewServer creates a new server instance.
func NewServer(ctx context.Context, cfg *Config) (*Server, error) {
	return &Server{}, nil
}

// Ping is a simple ping endpoint that returns "pong" + message when called
func (s *Server) Ping(ctx context.Context, message string) (string, error) {
	return "pong:" + message, nil
}

// Pong is a unary RPC that returns a pong message.
func (s *Server) Pong(ctx context.Context, message string) (string, error) {
	return "ping:" + message, nil
}

// Close is a dummy method which will always return an error. It is neither
// called nor used on the server, but is required by the api.Service interface.
func (s *Server) Close(_ context.Context) error {
	return fmt.Errorf("closing the server is not allowed")
}
