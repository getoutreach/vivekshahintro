// Copyright 2023 Outreach Corporation. All Rights Reserved.

// Description: This file contains the gRPC server passthrough implementation for the
// vivekshahintro API defined in api/vivekshahintro.proto. The concrete implementation
// exists in the server.go file in this same directory.
// Managed: true

package vivekshahintro //nolint:revive // Why: We allow [-_].

import (
	"context"
	"fmt"
	"net"

	"github.com/getoutreach/gobox/pkg/events"
	"github.com/getoutreach/gobox/pkg/log"
	"github.com/getoutreach/gobox/pkg/trace"
	"github.com/getoutreach/services/pkg/grpcx"
	"github.com/getoutreach/vivekshahintro/api"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	// imports added by modules
	"github.com/getoutreach/mint/pkg/authn"
	"github.com/getoutreach/tollmon/pkg/tollgate"
	"github.com/getoutreach/tollmon/pkg/tollway"
	"github.com/getoutreach/vivekshahintro/internal/lifecycle"
	// end imports added by modules
	// <<Stencil::Block(imports)>>
	// <</Stencil::Block>>
)

// GRPCDependencies is used to inject dependencies into the GRPCService service
// activity. Great examples of integrations to be placed into here would be a database
// connection or perhaps a redis client that the service activity needs to use.
type GRPCDependencies struct {
	// <<Stencil::Block(GRPCDependencies)>>

	// <</Stencil::Block>>
	// dependencies injected by modules
	TollwayProxy *tollway.Proxy
	// end dependencies injected by modules
}

// GRPCService is the concrete implementation of the serviceActivity interface
// which defines methods to start and stop a service. In this case the service
// being implemented is a gRPC server.
type GRPCService struct {
	cfg  *Config
	deps *GRPCDependencies
}

// NewGRPCService creates a new GRPCService instance.
func NewGRPCService(cfg *Config, deps *GRPCDependencies) *GRPCService {
	return &GRPCService{
		cfg:  cfg,
		deps: deps,
	}
}

// Servers holds all the server implementation instances.
type Servers struct {
	DefaultServer api.Service
	// Add your additional RPC servers here
	// <<Stencil::Block(servers)>>

	// <</Stencil::Block>>
}

// Run starts a gRPC server.
//
//nolint:funlen // Why: This function is long for extensibility reasons since it is generated by stencil.
func (gs *GRPCService) Run(ctx context.Context) error {
	lc := &net.ListenConfig{}
	listAddr := fmt.Sprintf("%s:%d", gs.cfg.ListenHost, gs.cfg.GRPCPort)
	lis, err := lc.Listen(ctx, "tcp", listAddr)
	if err != nil {
		log.Error(ctx, "failed to listen", events.NewErrorInfo(err))
		return err
	}
	defer lis.Close()

	var servers = &Servers{}
	var opts []grpcx.ServerOption
	// Initialize your server instance here.
	//
	// <<Stencil::Block(server)>>
	server, err := NewServer(ctx, gs.cfg)
	if err != nil {
		log.Error(ctx, "failed to create new server", events.NewErrorInfo(err))
		return err
	}
	// <</Stencil::Block>>
	servers.DefaultServer = server

	srv, err := gs.StartServers(ctx, servers, opts...)
	if err != nil {
		log.Error(ctx, "failed to start server", events.NewErrorInfo(err))
		return err
	}
	defer srv.Stop()

	// Shutdown the server when the context is canceled
	go func() {
		<-ctx.Done()
		srv.GracefulStop()
	}()

	// Note: .Serve() blocks
	log.Info(ctx, "Serving GRPC Service on "+listAddr)
	if err := srv.Serve(lis); err != nil {
		log.Error(ctx, "unexpected grpc Serve error", events.NewErrorInfo(err))
		return err
	}

	return nil
}

// Close closes the gRPC server.
func (gs *GRPCService) Close(ctx context.Context) error {
	return nil
}

// StartServers starts a RPC server with the provided implementation.
func (gs *GRPCService) StartServers(ctx context.Context, servers *Servers, opts ...grpcx.ServerOption) (*grpc.Server, error) {
	// gRPC server option initialization injected by modules

	withAuthn := grpcx.WithAuthnContext(func(ctx context.Context, headers map[string][]string, method string) context.Context {
		if c := authn.FromHeaders(ctx, headers); c != nil {
			trace.AddInfo(ctx, c)
			return authn.ToContext(ctx, c)
		}
		return ctx
	})

	tg := tollgate.New("vivekshahintro",
		tollgate.WithMonitoringMode(true),
		// <<Stencil::Block(tollgateOpts)>>
		tollgate.WithPartitionRules(tollgate.PartitionByOrgGUID),
		// <</Stencil::Block>>
	)
	gs.deps.TollwayProxy.RegisterClient(tg)
	// end gRPC server option initialization injected by modules

	opts = append([]grpcx.ServerOption{
		// gRPC server options injected by modules
		tg.WithUnaryServerInterceptorx(),
		withAuthn,
		// end gRPC server options injected by modules
	}, opts...)

	// <<Stencil::Block(grpcServerOptions)>>

	// <</Stencil::Block>>

	s, err := grpcx.NewServer(ctx, opts...)
	if err != nil {
		return nil, err
	}
	// gRPC RPCs injected by modules
	// Register tollway RPCs for rate-limiting purposes.
	gs.deps.TollwayProxy.RegisterRPCs(s)
	// Register service to invoke org lifecycle hooks
	lifecycle.OrgService(s)
	// end gRPC RPCs injected by modules

	// Register default server, title function won't work well when use underscore, so we make it dash first
	api.RegisterVivekshahintroServer(s, rpcserver{servers.DefaultServer})

	// Register your additional RPC servers here
	// <<Stencil::Block(registrations)>>

	// <</Stencil::Block>>

	// Register reflection
	reflection.Register(s)

	return s, nil
}

// rpcserver is a shim that converts the generic Service interface
// into the grpc generated interface from the protobuf
type rpcserver struct {
	api.Service
}

// Place any GRPC handler functions for your service here
//
// <<Stencil::Block(handlers)>>

// Ping is a simple ping/pong handler.
func (s rpcserver) Ping(ctx context.Context, req *api.PingRequest) (*api.PingResponse, error) {
	message, err := s.Service.Ping(ctx, req.Message)
	if err != nil {
		return nil, err
	}
	return &api.PingResponse{Message: message}, nil
}

// Pong is a simple RPC that returns a message.
func (s rpcserver) Pong(ctx context.Context, req *api.PongRequest) (*api.PongResponse, error) {
	message, err := s.Service.Pong(ctx, req.Message)
	if err != nil {
		return nil, err
	}
	return &api.PongResponse{Message: message}, nil
}
func (s rpcserver) Joke(ctx context.Context, req *api.JokeRequest) (*api.JokeResponse, error) {
	joke, err := s.Service.Joke(ctx)
	if err != nil {
		return nil, err
	}
	return &api.JokeResponse{Joke: joke}, nil
}

// <</Stencil::Block>>
