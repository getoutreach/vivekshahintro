
<!-- Space: https://outreach-io.atlassian.net/wiki/spaces/SP/overview?homepageId=2320568393 -->
<!-- Parent: Service Documentation 🧊 -->
<!-- Parent: vivekshahintro 🧊 -->
<!-- Parent: vivekshahintro Runbooks 🧊 -->
<!-- Title: vivekshahintro Pod Memory 🧊 -->

# Vivekshahintro Pod Memory.\<type\> > 80% of limit last 30m

Memory high alerts will occur if the memory rate is too high over x amount of time. The net impact is that customers might start seeing failures in Vivekshahintro requests. On the other hand, none of the above might actually happen and the memory usage might drop down on its own. If the High Memory usage keeps repeating for the same host, there might be something wrong with the host itself and it might need recycling - all of this is described in much more detail below.

## Investigation

### Datadog Dashboard and Logs

[Navigate to the `Terraform: Vivekshahintro` dashboard]() and find the "Total Memory" monitor under
the "Deployment" pane. Zero-in on a time frame where memory spiked, note that time frame, and change the window of
the dashboard to that time frame. Correlate any other useful monitors to see what could be causing this - look at
various sources of traffic like gRPC or HTTP. Looking at logs at the same time frame may also be useful using the
`kube_namespace:vivekshahintro--<bento>` facet.

Also look at the trending memory widget in the dashboard to look for patterns or timing that can be correlated with service activity.

To look for signs of issues or abnormal behavior in the logs, [navigate to Datadog](https://app.datadoghq.com/logs?query=service%3Avivekshahintro%20status%3Aerror) and
add the `@deployment.bento:<bento>` facet, where `<bento>` is the bento that this alert fired in.

<!-- <<Stencil::Block(podMemorySpikeDatadog)>> -->

<!-- <</Stencil::Block>> -->

### Honeycomb

If there are a large volume of requests that trigger the issue some information on the details of the requests may be available in Honeycomb. Note that Honeycomb samples requests (usually with a low sampling rate of 1%) so for low frequency issues the odds of finding something specific in Honeycomb are low.

[Navigate to Honeycomb](https://ui.honeycomb.io/outreach-a0/datasets/outreach?query=%7B%22time_range%22%3A7200%2C%22granularity%22%3A0%2C%22breakdowns%22%3A%5B%22name%22%5D%2C%22calculations%22%3A%5B%7B%22op%22%3A%22P95%22%2C%22column%22%3A%22duration_ms%22%7D%2C%7B%22op%22%3A%22HEATMAP%22%2C%22column%22%3A%22duration_ms%22%7D%5D%2C%22filters%22%3A%5B%7B%22column%22%3A%22app.name%22%2C%22op%22%3A%22%3D%22%2C%22value%22%3A%22vivekshahintro%22%7D%5D%2C%22filter_combination%22%3A%22AND%22%2C%22orders%22%3A%5B%7B%22column%22%3A%22duration_ms%22%2C%22op%22%3A%22P95%22%2C%22order%22%3A%22descending%22%7D%5D%2C%22havings%22%3A%5B%5D%2C%22limit%22%3A1000%7D) 
and add `deployment.namespace = vivekshahintro--<bento>` to the `WHERE` clause, where `<bento>` is the bento that
this alert fired in. These traces may provide an idea as to what could be the root cause of the errors.

<!-- <<Stencil::Block(podMemorySpikeHoneycomb)>> -->

<!-- <</Stencil::Block>> -->

## Resolution

Once you determine what the errors are, they fall usually fall into one of several categories categories:

1. Too many requests: If the number of requests drops, then the service should recover on it’s own.

2. Hardware error: The solution is to restart the pod. The simplest way to due this is by triggering a new deployment with:

```shell
orc context <bento>
kubectl -n vivekshahintro--<bento> rollout restart deployment vivekshahintro
```

Verify the pods are cycling by executing:

```shell
kubectl -n vivekshahintro--<bento> get pods
```

and verifying the pods are restarting, or recently restarted.

<!-- <<Stencil::Block(podMemorySpikeResolution)>> -->

<!-- <</Stencil::Block>> -->

<!-- <<Stencil::Block(podMemorySpike)>> -->

<!-- <</Stencil::Block>> -->
