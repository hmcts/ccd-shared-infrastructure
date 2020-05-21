
resource "azurerm_monitor_action_group" "ccd-alert-action-group" {
  name                = "CCD Alerts (${var.env})"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  short_name          = "ccd_alerts"
  email_receiver {
    name          = "CCD Alerts And Monitoring"
    email_address = "${data.azurerm_key_vault_secret.alert_ccd_email_secret.value}"
  }




}