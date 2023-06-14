// Copyright 2023 Outreach Corporation. All Rights Reserved.

// Description: This file contains the gRPC server implementation for the vivekshahintro
// API defined in api/vivekshahintro.proto. This implementation is used in the
// rpc.go when creating and exposing the gRPC server.

package vivekshahintro //nolint:revive // Why: We allow [-_].
import (
	"context"
	"fmt"
	"net/http"

	"github.com/getoutreach/httpx/pkg/fetch"
	"github.com/getoutreach/mint/pkg/authn"
	"github.com/google/uuid"
)

// Server is the actual server implementation of the API.
//
// Note that tracing, logging and metrics are already handled for these
// methods.
type Server struct {
	// Place any handler state for your service here.
	cfg *Config
}

// NewServer creates a new server instance.
func NewServer(ctx context.Context, cfg *Config) (*Server, error) {
	return &Server{cfg}, nil
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

func (s *Server) Joke(ctx context.Context) (string, error) {
	r := fetch.NewRequest(ctx, http.MethodGet, "https://icanhazdadjoke.com/", nil, nil)
	r = r.Accept("text/plain")
	re := fetch.Do(fetch.External("icanhazdadjoke"), r)
	defer re.Close()

	text, err := re.CheckStatus().LimitBodySize(1000).Text()
	if err != nil {
		return "", err
	}

	org := authn.CurrentOrgGUID(ctx)

	// recall that we defined the name of the element of the PostgreSQL map to
	// be {{ .ServiceName }} in service.yaml above. If we had multiple resources
	// we might need to use a more descriptive name.
	conn, err := s.cfg.ConnMap["{{ .ServiceName }}"].Writer(ctx, uuid.UUID(org))
	if err != nil {
		return "", err
	}

	res, err := conn.ExecContext(ctx, `
        INSERT INTO jokes (joke, last_told) VALUES ($1, now()) ON CONFLICT DO NOTHING
    `, text)
	if err != nil {
		return "", err
	}

	count, err := res.RowsAffected()
	if err != nil {
		return "", err
	}
	if count == 0 {
		// recursion — find another joke
		return s.Joke(ctx)
	}

	return text, err
}
