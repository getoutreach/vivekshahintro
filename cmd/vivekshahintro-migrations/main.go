// Copyright 2023 Outreach Corporation. All Rights Reserved.

// Description: This file is the entrypoint for schema migrations.
// Managed: true

// Package main implements the main entrypoint for schema migrations.
//
// To build this package do:
//
//	make
//
// To run this do:
//
//	./bin/migrations <managed resource>
//
// To run with honeycomb enabled do: (Note: the below section assumes you have go-outreach cloned somewhere.)
//
//	$> pushd <go-outreach>
//	$> ./scripts/devconfig.sh
//	$> vault kv get -format=json dev/honeycomb/dev-env | jq -cr '.data.data.apiKey' > ~/.outreach/honeycomb.key
//	$> popd
//	$> ./scripts/devconfig.sh
//	$> ./bin/migrations
package main

import (
	"context"
	"fmt"
	"os"

	"github.com/sirupsen/logrus"
	"github.com/urfave/cli/v2"

	oapp "github.com/getoutreach/gobox/pkg/app"
	gcli "github.com/getoutreach/gobox/pkg/cli"
	"github.com/getoutreach/gobox/pkg/events"
	"github.com/getoutreach/gobox/pkg/log"
	"github.com/getoutreach/gobox/pkg/trace"

	"github.com/getoutreach/smartstore/pkg/migrations"
	"github.com/getoutreach/smartstore/pkg/smartstore"
)

// HoneycombTracingKey gets set by the Makefile at compile-time which is pulled
// down by devconfig.sh.
var HoneycombTracingKey = "NOTSET" //nolint:gochecknoglobals // Why: We can't compile in things as a const.

// TeleforkAPIKey gets set by the Makefile at compile-time which is pulled
// down by devconfig.sh.
var TeleforkAPIKey = "NOTSET" //nolint:gochecknoglobals // Why: We can't compile in things as a const.

// HoneycombDataset use the default dataset by default
var HoneycombDataset = ""

func main() {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	logrs := logrus.New()

	app := cli.App{
		Version: oapp.Version,
		Name:    "migrations",
		Flags: []cli.Flag{
			&cli.StringFlag{
				Name:  "schema_path",
				Value: smartstore.DefaultSchemaBasePath,
			},
		},
		Before: func(ctx *cli.Context) error {
			log.SetOutput(os.Stderr)
			return nil
		},
		Action: func(c *cli.Context) error {
			if err := trace.InitTracer(ctx, "vivekshahintro"); err != nil {
				log.Error(ctx, "tracing failed to start", events.Err(err))
				os.Exit(1)
			}
			defer trace.CloseTracer(ctx)

			if err := migrations.Run(ctx, c.String("schema_path"), c.Args().Slice()...); err != nil {
				fmt.Printf("error %+v\n", err)
				log.Error(ctx, "error", events.NewErrorInfo(err))
				return err
			}
			log.Info(ctx, "migrations completed, ok")
			return nil
		},
	}

	// Insert global flags, tracing, updating and start the application.
	gcli.HookInUrfaveCLI(ctx, cancel, &app, logrs,
		HoneycombTracingKey, HoneycombDataset, TeleforkAPIKey)
}
