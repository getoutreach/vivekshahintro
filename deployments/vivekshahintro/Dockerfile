# syntax=docker/dockerfile:1.0-experimental
FROM gcr.io/outreach-docker/golang:1.19.8 as builder
ARG VERSION
ENV GOCACHE "/go-build-cache"
ENV GOPRIVATE github.com/getoutreach/*
ENV CGO_ENABLED 0
WORKDIR /src

# Copy our source code into the container for building
COPY . .

## <<Stencil::Block(beforeBuild)>>

## <</Stencil::Block>>

# Cache dependencies across builds
RUN --mount=type=ssh --mount=type=cache,target=/go/pkg go mod download

# Build our application, caching the go build cache, but also using
# the dependency cache from earlier.
RUN --mount=type=ssh --mount=type=cache,target=/go/pkg --mount=type=cache,target=/go-build-cache \
    mkdir -p bin; \
    go build -o /src/bin/ -ldflags "-X github.com/getoutreach/gobox/pkg/app.Version=$VERSION" -v ./cmd/...

FROM gcr.io/outreach-docker/alpine:3.16
ENTRYPOINT ["/usr/local/bin/vivekshahintro"]

LABEL "io.outreach.reporting_team"="ce-success-plans-services"
LABEL "io.outreach.repo"="vivekshahintro"

# Add timezone information.
COPY --from=builder /usr/local/go/lib/time/zoneinfo.zip /zoneinfo.zip
ENV ZONEINFO=/zoneinfo.zip

# Install certificates for RDS connectivity.
RUN apk add --no-cache curl \
    &&  curl "https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem" --output /usr/local/share/ca-certificates/rds-combined-ca-bundle.pem \
    &&  update-ca-certificates \
    &&  apk del --no-cache curl

## <<Stencil::Block(afterBuild)>>

## <</Stencil::Block>>

COPY --from=builder /src/bin/vivekshahintro /usr/local/bin/vivekshahintro

# Begin afterBuild module hook entries

# Smartstore Integration
COPY --from=builder /src/bin/vivekshahintro-migrations /usr/local/bin/vivekshahintro-migrations
COPY --from=builder /src/migrations /run/config/outreach.io/migrations
# The below bin is needed for administrative actions like shard split/apply
RUN apk add --no-cache postgresql-client
COPY --from=gcr.io/outreach-docker/smartstore:v1.112.6 /usr/local/bin/smartstore /usr/local/bin/smartstore

# End afterBuild module hook entries
USER systemuser
