# Fill these in with DataDog users/integrations to notify, clerk P1/P2 alerts are
# provisioned for this service only if Clerk_P1_notify/Clerk_P2_notify is non-empty.
# For more details: https://outreach-io.atlassian.net/wiki/spaces/CDT/pages/2560163956/Clerk+Alerts+and+Runbooks
// <<Stencil::Block(clerkNotificationChannels)>>
locals {
  Clerk_P1_notify = []
  Clerk_P2_notify = []
}
// <</Stencil::Block>>

module "clerk_kafka_dashboard" {
  # for available variables: https://github.com/getoutreach/clerk-monitoring/blob/main/modules/kafka/variables.tf
  source = "git@github.com:getoutreach/clerk-monitoring.git//modules/kafka"
  # custom dashboard configuration here, e.g. title
  // <<Stencil::Block(kafkaConfig)>>

  // <</Stencil::Block>>
  reporting_team = "ce-success-plans-services"
  repo           = "vivekshahintro"
  p1_notify      = join(" ", local.Clerk_P1_notify)
  p2_notify      = join(" ", local.Clerk_P2_notify)
  apps = [
    {
      name = "vivekshahintro",
      topics = [
      ]
    },
    // <<Stencil::Block(extraKafkaApps)>>

    // <</Stencil::Block>>
  ]
}
