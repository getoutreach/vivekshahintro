
resource "datadog_service_level_objective" "grpc_success" {
  name        = "Vivekshahintro GRPC Success Response"
  type        = "metric"
  description = "Comparing (status:ok) responses to all requests as a ratio, broken out by bento."
  tags        = local.ddTags
  query {
    numerator   = "clamp_min(default_zero(count:${local.grpc_request_source}{${join(", ", var.grpc_tags)},app:vivekshahintro, !statuscategory:categoryservererror} by {kube_namespace}.as_count()), 1)"
    denominator = "clamp_min(default_zero(count:${local.grpc_request_source}{${join(", ", var.grpc_tags)},app:vivekshahintro} by {kube_namespace}.as_count()), 1)"
  }
  thresholds {
    timeframe = "7d"
    target    = 99.9
    warning   = 99.95
  }
}

resource "datadog_service_level_objective" "grpc_p99_latency" {
  name        = "Vivekshahintro GRPC P99 Latency"
  type        = "monitor"
  description = "Keeping track of P99 latency commitments for all Vivekshahintro GRPC requests in aggregate, for production bentos only."
  tags        = local.ddTags
  monitor_ids = [module.grpc_latency_high.high_traffic_id]
  groups = [
    "kube_namespace:vivekshahintro--ops",
  ]
  thresholds {
    timeframe = "7d"
    target    = 99.9
    warning   = 99.95
  }
}

// <<Stencil::Block(tfCustomSLODatadog)>>

// <</Stencil::Block>>
