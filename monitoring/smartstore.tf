module "smartstore_db_dashboard" {
  source               = "git@github.com:getoutreach/database-monitoring.git//modules/smartstore/database?ref=35a6f51"
  outreach_application = "vivekshahintro"
  P1_notify            = var.P1_notify
  P2_notify            = var.P2_notify
  additional_dd_tags   = local.ddTags
}
