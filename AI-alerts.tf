
module "ccd-cpu-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"
  # enabled    = "${var.env == "prod"}"
  alert_name = "ccd-cpu-alert"
  alert_desc = "Fires when Max CPU Processor Time is Greater than 85% within a 10 minute window timeframe."

  app_insights_query = <<EOF
performanceCounters
| where category == "Processor" and name == "% Processor Time"
| summarize ['CPU'] = avg(value) 
EOF

  frequency_in_minutes       = 10
  time_window_in_minutes     = 10
  severity_level             = "1"
  action_group_name          = "${azurerm_monitor_action_group.ccd-alert-action-group.name}"
  custom_email_subject       = "CCD Excessive CPU Alert"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 85
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}

module "ccd-mem-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"
  # enabled    = "${var.env == "prod"}"
  alert_name = "ccd-mem-alert"
  alert_desc = "Fires when time in GC is over 3.4s within a 10 minute window timeframe."

  app_insights_query = <<EOF
performanceCounters
| where counter == "GC Total Time" 
| where cloud_RoleName in ("ccd-user-profile", "ccd-data-store", "ccd-definition-store")
| summarize ['x'] = avg(value) 
| extend todecimal(x) 
EOF

  frequency_in_minutes       = 10
  time_window_in_minutes     = 10
  severity_level             = "1"
  action_group_name          = "${azurerm_monitor_action_group.ccd-alert-action-group.name}"
  custom_email_subject       = "CCD Excessive GC Time Alert"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 3400
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_monitor_metric_alert" "pg-user-prof-db-cpu" {
  name                = "pg-db-user-prof-cpu"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  # enabled             = "${var.env == "prod"}"
  scopes              = ["/subscriptions/${var.subscription_id}/resourceGroups/ccd-user-profile-api-postgres-db-data-${var.env}/providers/Microsoft.DBforPostgreSQL/servers/ccd-user-profile-api-postgres-db-${var.env}"]
  description         = "Action will be triggered when the CPU utilization is greater than 80%"
  severity            = "1"
  frequency           = "PT5M"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/servers"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }
  action {
    action_group_id = "${azurerm_monitor_action_group.ccd-alert-action-group.id}"
  }
}

resource "azurerm_monitor_metric_alert" "pg-user-prof-db-mem" {
  name                = "pg-db-user-prof-mem"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  # enabled             = "${var.env == "prod"}"
  scopes              = ["/subscriptions/${var.subscription_id}/resourceGroups/ccd-user-profile-api-postgres-db-data-${var.env}/providers/Microsoft.DBforPostgreSQL/servers/ccd-user-profile-api-postgres-db-${var.env}"]
  description         = "Action will be triggered when the Memory utilization is greater than 80%"
  severity            = "1"
  frequency           = "PT5M"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/servers"
    metric_name      = "memory_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }
  action {
    action_group_id = "${azurerm_monitor_action_group.ccd-alert-action-group.id}"
  }
}

resource "azurerm_monitor_metric_alert" "pg-data-store-db-cpu" {
  name                = "pg-db-data-store-cpu"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  # enabled             = "${var.env == "prod"}"
  scopes              = ["/subscriptions/${var.subscription_id}/resourceGroups/ccd-data-store-api-postgres-db-data-${var.env}/providers/Microsoft.DBforPostgreSQL/servers/ccd-data-store-api-postgres-db-${var.env}"]
  description         = "Action will be triggered when the CPU utilization is greater than 80%"
  severity            = "1"
  frequency           = "PT5M"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/servers"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }
  action {
    action_group_id = "${azurerm_monitor_action_group.ccd-alert-action-group.id}"
  }
}

resource "azurerm_monitor_metric_alert" "pg-data-store-db-mem" {
  name                = "pg-db-data-store-mem"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  # enabled             = "${var.env == "prod"}"
  scopes              = ["/subscriptions/${var.subscription_id}/resourceGroups/ccd-data-store-api-postgres-db-data-${var.env}/providers/Microsoft.DBforPostgreSQL/servers/ccd-data-store-api-postgres-db-${var.env}"]
  description         = "Action will be triggered when the Memory utilization is greater than 80%"
  severity            = "1"
  frequency           = "PT5M"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/servers"
    metric_name      = "memory_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }
  action {
    action_group_id = "${azurerm_monitor_action_group.ccd-alert-action-group.id}"
  }
}

resource "azurerm_monitor_metric_alert" "pg-def-store-db-cpu" {
  name                = "pg-db-def-store-cpu"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  # enabled             = "${var.env == "prod"}"
    scopes              = ["/subscriptions/${var.subscription_id}/resourceGroups/ccd-definition-store-api-postgres-db-data-${var.env}/providers/Microsoft.DBforPostgreSQL/servers/ccd-definition-store-api-postgres-db-${var.env}"]
  description         = "Action will be triggered when the CPU utilization is greater than 80%"
  severity            = "1"
  frequency           = "PT5M"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/servers"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }
  action {
    action_group_id = "${azurerm_monitor_action_group.ccd-alert-action-group.id}"
  }
}

resource "azurerm_monitor_metric_alert" "pg-def-store-db-mem" {
  name                = "pg-db-def-store-mem"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  # enabled             = "${var.env == "prod"}"
  scopes              = ["/subscriptions/${var.subscription_id}/resourceGroups/ccd-definition-store-api-postgres-db-data-${var.env}/providers/Microsoft.DBforPostgreSQL/servers/ccd-definition-store-api-postgres-db-${var.env}"]
  description         = "Action will be triggered when the Memory utilization is greater than 80%"
  severity            = "1"
  frequency           = "PT5M"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/servers"
    metric_name      = "memory_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }
  action {
    action_group_id = "${azurerm_monitor_action_group.ccd-alert-action-group.id}"
  }
}