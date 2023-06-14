# vivekshahintro
[![go.dev reference](https://img.shields.io/badge/go.dev-reference-007d9c?logo=go&logoColor=white)](https://engdocs.outreach.cloud/github.com/getoutreach/vivekshahintro)
[![Generated via Bootstrap](https://img.shields.io/badge/Outreach-Bootstrap-%235951ff)](https://github.com/getoutreach/bootstrap)
[![Coverage Status](https://coveralls.io/repos/github/getoutreach/vivekshahintro/badge.svg?branch=main)](https://coveralls.io/github//getoutreach/vivekshahintro?branch=main)
<!-- <<Stencil::Block(extraBadges)>> -->

<!-- <</Stencil::Block>> -->

Tutorial service for the purpose of enlightenment and enrichment

## Contributing

Please read the [CONTRIBUTING.md](CONTRIBUTING.md) document for guidelines on developing and contributing changes.

## High-level Overview

<!-- <<Stencil::Block(overview)>> -->

<!-- <</Stencil::Block>> -->
## Dependencies
Make sure you've ran `orc setup`.

### Dependencies

### Adding and Deleting Service in Development Environment

First, make sure you [set up your development environment](https://github.com/getoutreach/devenv#getting-started).

To add this service to your developer environment:
```bash
devenv apps deploy vivekshahintro
```

To delete this service from your developer environment:
```bash
devenv apps delete vivekshahintro
```
## Interacting with Vivekshahintro
### via gRPC

[grpcui](https://github.com/fullstorydev/grpcui) can be useful for talking to vivekshahintro locally. To run it:

```bash
make grpcui
```
