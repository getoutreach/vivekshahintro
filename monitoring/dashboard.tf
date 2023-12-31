# This file is managed by stencil.  Changes outside of `Block`s will be
# clobbered next time it is run.

# This file defines a very generic infrastructure-level dashboard.  It provides
# visibility into service attributes that are generic across services, like k8s
# metrics or counts of gRPC calls.
#
# Most services will need more dashboards that include more service-specific
# information.  You can define them in the Datadog UI or a separate `.tf` file
# in this directory according to your preference.

# Pro tip: For best results, visit
# https://app.datadoghq.com/metric/summary?metric=vivekshahintro.grpc_request_handled
# and set the unit metadata to "seconds".  This will make the y axes on some of
# these charts much more readable.

locals {
  dashboard_parameters = [
    {
      name    = "bento"
      prefix  = "bento"
      default = "*"
    },
    {
      name    = "env"
      prefix  = "env"
      default = "*"
    },
    // <<Stencil::Block(customDashboardParams)>>

    // <</Stencil::Block>>
  ]
}

# Header section: Here we include descriptions, links and other info.

locals {
  standard_links = [
    "[GitHub](https://github.com/getoutreach/vivekshahintro)",
    "[Engdocs](https://engdocs.outreach.cloud/github.com/getoutreach/vivekshahintro)",
    "[Logs](https://app.datadoghq.com/logs?cols=service%2C%40bento%2Csource&from_ts=1601507372082&index=main&live=true&messageDisplay=expanded-md&stream_sort=desc&to_ts=1601508272082&query=service%3Avivekshahintro)",
    "[Honeycomb](https://ui.honeycomb.io/outreach-a0/datasets/outreach?query=%7B%22breakdowns%22%3A%5B%22service_name%22%2C%22name%22%2C%22deployment.bento%22%5D%2C%22calculations%22%3A%5B%7B%22op%22%3A%22COUNT%22%7D%2C%7B%22column%22%3A%22duration_ms%22%2C%22op%22%3A%22P90%22%7D%2C%7B%22column%22%3A%22duration_ms%22%2C%22op%22%3A%22HEATMAP%22%7D%5D%2C%22filters%22%3A%5B%7B%22column%22%3A%22service_name%22%2C%22op%22%3A%22exists%22%2C%22join_column%22%3A%22%22%7D%2C%7B%22column%22%3A%22service_name%22%2C%22op%22%3A%22%3D%22%2C%22value%22%3A%22vivekshahintro%22%2C%22join_column%22%3A%22%22%7D%5D%2C%22orders%22%3A%5B%7B%22op%22%3A%22COUNT%22%2C%22order%22%3A%22descending%22%7D%5D%2C%22limit%22%3A1000%2C%22time_range%22%3A604800%7D)",
    "[Owning GitHub team](https://github.com/orgs/getoutreach/teams/ce-success-plans-services)",
    "[Deployment Slack](https://slack.com/app_redirect?channel=)",
    "[Concourse CI/CD](https://concourse.outreach.cloud/teams/devs/pipelines/vivekshahintro)",
  ]
  custom_links = [
    // <<Stencil::Block(customLinks)>>

    // <</Stencil::Block>>
  ]

  formatted_links    = join("\n", formatlist("- %s", concat(local.standard_links, local.custom_links)))
  links_note_content = join("", ["See also:\n\n", local.formatted_links])
}

module "links_note" {
  source  = "git@github.com:getoutreach/monitoring-terraform.git//modules/dd-chart/generic/note"
  content = local.links_note_content
}

module "description_note" {
  source  = "git@github.com:getoutreach/monitoring-terraform.git//modules/dd-chart/generic/note"
  content = <<-EOF
    # Vivekshahintro

    This is the terraform-managed dashboard for the vivekshahintro service.
  EOF
}

locals {
  header_section = {
    name = "Vivekshahintro Service Info"
    charts = [
      module.description_note.rendered,
      module.links_note.rendered,
    ]
  }
}

# Deployment section: k8s-level service information.

module "deployment" {
  source     = "git@github.com:getoutreach/monitoring-terraform.git//modules/dd-sections/generic_deployment"
  deployment = "vivekshahintro"
}

locals {
  prefix = true
}

# NOTE: applies for most of the gRPC sections below.
#
# The term "calls" is a bit misleading here.  The metrics series do not clearly
# differentiate between calls made by the service and calls into this service.
# We need to fix that at the metrics level then update these charts accordingly.
#  See https://outreach-io.atlassian.net/browse/DT-294.
#
# Until that's fixed, you could try adding sections for particular kinds of
# calls.  When this template is instantiated with `call` arguments that match
# the name of a particular gRPC method then you'll see only the top-level
# requests for that method and you won't need to worry about the hetorgenous
# mix of calls in the unfiltered metric.

# This section shows call/request counts in details
#
# Charts on display in this section are:
# - total number of calls/requests within selected time period
# - timeseries of calls per status (ok/error)
# - timeseries of calls per bento
# - top list of "busy" bentos
# - top list of "popular" calls
# - RPS, average for the selected time period
# - RPS, timeseries
# - RPM, average for the selected time period
# - RPM, timeseries

module "grpc_load" {
  source     = "git@github.com:getoutreach/bootstrap-terraform.git//monitoring/datadog/section/grpc/load?ref=v1.3.0"
  deployment = "vivekshahintro"
  prefix     = local.prefix
}

# This section shows performance/latency of calls.
#
# Charts on display in this section are:
# - P99 latency, average for the selected time period
# - P99 latency, timeseries
# - P99 latency, top "slow" bentos
# - P95 latency, average for the selected time period
# - P95 latency, timeseries
# - P95 latency, top "slow" bentos
# - table of latencies per percentile
# - table of latencies per percentile and bento
# - table of latencies per percentile and call type
# - P99/95/90/75/50 latency, timeseries
#
# This section uses a pair of threshold variables
# that can be overriden in `terraform.tfvars`.

variable "Latency_red_line_ms" {
  type    = number
  default = 500
}
variable "Latency_yellow_line_ms" {
  type    = number
  default = 200
}

module "grpc_performance" {
  source     = "git@github.com:getoutreach/bootstrap-terraform.git//monitoring/datadog/section/grpc/perf?ref=v1.3.0"
  deployment = "vivekshahintro"
  prefix     = local.prefix
}



# This section shows QoS and rate of successfully finished calls.
#
# Charts on display in this section are:
# - Success rate, average for the selected time period
# - Success rate, timeseries
# - Success rate by bento
# - Success rate, top "error producing" bentos
# - Success rate, top "error producing" calls
# - Top list of error status codes
# - Error counts, timeseries
#
# This section uses a pair of threshold variables
# that can be overriden in `terraform.tfvars`.

variable "Qos_red_line" {
  type    = number
  default = 98
}
variable "Qos_yellow_line" {
  type    = number
  default = 99
}

module "grpc_qos" {
  source     = "git@github.com:getoutreach/bootstrap-terraform.git//monitoring/datadog/section/grpc/qos?ref=v1.3.0"
  deployment = "vivekshahintro"
  prefix     = local.prefix
}

# This section shows calls activity per bento.
# It also highlights anomalies in call patterns compared to the metrics
# reported in the past.

module "grpc_bento_activity" {
  source     = "git@github.com:getoutreach/bootstrap-terraform.git//monitoring/datadog/section/grpc/activity?ref=v1.3.0"
  deployment = "vivekshahintro"
  prefix     = local.prefix
}

# You can define additional sections here if needed.

// <<Stencil::Block(sectionDefinitions)>>
# If you would like to instantiate additional dashboard section templates, you
# can do so here.  For example, if you wanted to include standard charts for
# some hypothetical "pongrequest" gRPC call, you could do:
#
# module "grpc_pongrequest" {
#   source     = "git@github.com:getoutreach/monitoring-terraform.git//modules/dd-sections/bootstrap_grpc"
#   deployment = "vivekshahintro"
#   call       = "api.vivekshahintro.pongrequest"
# }
#
# Don't forget to instantiate the new section by referencing it in the
# dashboard definition below.
// <</Stencil::Block>>

# Here we render the dashboard.

module "dashboard" {
  source      = "git@github.com:getoutreach/monitoring-terraform.git//modules/dd-dashboards"
  name        = "Terraform: Vivekshahintro"
  description = "Managed by terraform in github.com/getoutreach/vivekshahintro"

  parameters = local.dashboard_parameters
  sections = [
    local.header_section,
    module.grpc_load.rendered,
    module.grpc_performance.rendered,
    module.grpc_qos.rendered,
    module.grpc_bento_activity.rendered,
    module.deployment.rendered,
    // <<Stencil::Block(sectionReferences)>>

    // <</Stencil::Block>>
  ]
}
