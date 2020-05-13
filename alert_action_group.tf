data "azurerm_key_vault_secret" "alert_ccd_email_secret" {
  name      = "ccd-alert-email"
  vault_uri = "${module.vault.key_vault_uri}"
}

module "alert-action-group" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = "${var.env}"

  resourcegroup_name     = "${azurerm_resource_group.rg.name}"
  action_group_name      = "CCD Alerts (${var.env})"
  short_name             = "ccd_alerts"
  email_receiver_name    = "CCD Alerts And Monitoring"
  email_receiver_address = "${data.azurerm_key_vault_secret.alert_ccd_email_secret.value}"
}

resource "azurerm_key_vault_secret" "alert_action_group_name" {
  name = "alert-action-group-name"
  value = "${module.alert-action-group.action_group_name}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

output "action_group_name" {
  value = "${module.alert-action-group.action_group_name}"
}