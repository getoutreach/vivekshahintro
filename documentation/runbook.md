
<!-- Space: https://outreach-io.atlassian.net/wiki/spaces/SP/overview?homepageId=2320568393 -->
<!-- Parent: Service Documentation 🧊 -->
<!-- Parent: vivekshahintro 🧊 -->
<!-- Title: vivekshahintro Runbooks 🧊 -->

# vivekshahintro Runbooks

## Index of Runbooks

* [Available Pods Low](./runbooks/available-pods-low.md)
* [Pod CPU > \<threshold\>% of request last \<window\>m](./runbooks/pod-cpu.md)
* [Pod Memory.\<type\> > 80% of limit last 30m](./runbooks/pod-memory.md)
* [Pod Restarts > \<threshold\> last 30m](./runbooks/pod-restarts.md)
* [Service Panics](./runbooks/service-panics.md)
* [gRPC Latency High](./runbooks/grpc-latency-high.md)
* [gRPC Success Rate Low](./runbooks/grpc-success-rate-low.md)
<!-- <<Stencil::Block(additionalRunbookLinks)>> -->

<!-- <</Stencil::Block>> -->

## General Debugging

### Kubernetes Resources

To view all of the kubernetes resources created by vivekshahintro, use the following command after
switching into the appropriate context using `orc context`:

```shell
kubectl -n vivekshahintro--<bento> get all
```

<!-- <<Stencil::Block(generalDebugging)>> -->

<!-- <</Stencil::Block>> -->
