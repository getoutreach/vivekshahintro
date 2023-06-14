
<!-- Space: https://outreach-io.atlassian.net/wiki/spaces/SP/overview?homepageId=2320568393 -->
<!-- Parent: Service Documentation 🧊 -->
<!-- Parent: vivekshahintro 🧊 -->
<!-- Parent: vivekshahintro Runbooks 🧊 -->
<!-- Title: vivekshahintro Pod CPU 🧊 -->

# Vivekshahintro Pod CPU > \<threshold\>% of request last \<window\>m

CPU high alerts will occur if the CPU rate is too high over x amount of time. The net impact is that customers might start seeing failures in Vivekshahintro requests. On the other hand, none of the above might actually happen and the CPU usage might drop down on its own. If the High CPU usage keeps repeating for the same host, there might be something wrong with the host itself and it might need recycling - all of this is described in much more detail below.

<!-- <<Stencil::Block(podCPUSpikeOverview)>> -->

<!-- <</Stencil::Block>> -->

## Investigation

### Datadog Dashboard and Logs

[Navigate to the `Terraform: Vivekshahintro` dashboard]() and find the "Total CPU" monitor under
the "Deployment" pane. Zero-in on a time frame where CPU spiked, note that time frame, and change the window of
the dashboard to that time frame. Correlate any other useful monitors to see what could be causing this - look at
various sources of traffic like gRPC or HTTP. Looking at logs at the same time frame may also be useful using the
`kube_namespace:vivekshahintro--<bento>` facet.

Look for any anomalies in the dashboard.

To look for signs of issues or abnormal behavior in the logs, [navigate to Datadog](https://app.datadoghq.com/logs?query=service%3Avivekshahintro%20status%3Aerror) and
add the `@deployment.bento:<bento>` facet, where `<bento>` is the bento that this alert fired in.

<!-- <<Stencil::Block(podCPUSpikeDatadog)>> -->

<!-- <</Stencil::Block>> -->

### Honeycomb

If there are a large volume of requests that trigger the issue some information on the details of the requests may be available in Honeycomb. Note that Honeycomb samples requests (usually with a low sampling rate of 1%) so for low frequency issues the odds of finding something specific in Honeycomb are low.

You can use the following as a starter Honeycomb query to begin looking for traces that exhibit the performance problems you are investigating.

<!-- <<Stencil::Block(grpcSuccessRateLowHoneycomb)>> -->

<!-- <</Stencil::Block>> -->

### Check the Pod CPU Usage Directly

You can get a real time view of current CPU utilization in the cluster by running the following command:

```shell
kubectl --context <context> -n vivekshahintro--<bento> top pod
```

Substitute the appropriate values for `<context>` and `<bento>` based on the environment and bento you want to modify. Refer to [Deployments](/documentation/deployments.md) for a mapping from bento to context.

The output of the top command will show the current CPU and memory usage for all of the pods running in the cluster. Look for pods with abnormally high values. You can view the logs for specific pods with the following command:

```shell
kubectl --context <context> -n vivekshahintro--<bento> log <pod_name>
```

where `<pod_name>` is the name of the pod exhibiting abnormal CPU usage.

<!-- <<Stencil::Block(podCPUSpikeDirect)>> -->

<!-- <</Stencil::Block>> -->

## Resolution

<!-- <<Stencil::Block(podCPUSpikeResolution)>> -->

<!-- <</Stencil::Block>> -->

<!-- <<Stencil::Block(podCPUSpike)>> -->

<!-- <</Stencil::Block>> -->
