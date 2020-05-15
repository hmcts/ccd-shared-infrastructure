
module "ccd-cpu-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  #   enabled    = "${var.env == "prod"}"
  alert_name = "ccd-cpu-alert"
  alert_desc = "Fires when Max CPU Processor Time is Greater than 85% within a 10 minute window timeframe."

  app_insights_query = <<EOF
performanceCounters
| where category == "Processor" and name == "% Processor Time"
| summarize ['CPU'] = max(value) 
EOF

  frequency_in_minutes       = 10
  time_window_in_minutes     = 10
  severity_level             = "1"
  action_group_name          = "${module.alert-action-group.action_group_name}"
  custom_email_subject       = "CCD Excessive CPU Alert"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 85
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}

module "ccd-mem-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  #   enabled    = "${var.env == "prod"}"
  alert_name = "ccd-mem-alert"
  alert_desc = "Fires when time in GC is over 3.4s within a 10 minute window timeframe."

  app_insights_query = <<EOF
performanceCounters
| where counter == "GC Total Time" 
| where cloud_RoleName in ("ccd-user-profile", "ccd-data-store", "ccd-definition-store")
| summarize ['x'] = max(value) 
| extend todecimal(x) 
EOF

  frequency_in_minutes       = 10
  time_window_in_minutes     = 10
  severity_level             = "1"
  action_group_name          = "${module.alert-action-group.action_group_name}"
  custom_email_subject       = "CCD Excessive GC Time Alert"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 3400
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}

