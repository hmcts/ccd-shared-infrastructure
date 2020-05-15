module "vault" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = "ccd-${var.env}"
  product                 = "${var.product}"
  env                     = "${var.env}"
  tenant_id               = "${var.tenant_id}"
  object_id               = "${var.jenkins_AAD_objectId}"
  resource_group_name     = "${azurerm_resource_group.rg.name}"
  product_group_object_id = "be8b3850-998a-4a66-8578-da268b8abd6b"

  common_tags = "${local.tags}"

  managed_identity_object_id = "${var.managed_identity_object_id}"
}

data "azurerm_key_vault" "s2s_vault" {
  name                = "s2s-${var.env}"
  resource_group_name = "rpe-service-auth-provider-${var.env}"
}

data "azurerm_key_vault_secret" "ccd_gw_s2s_key" {
  name         = "microservicekey-ccd-gw"
  key_vault_id = "${data.azurerm_key_vault.s2s_vault.id}"
}

resource "azurerm_key_vault_secret" "ccd_gw_s2s_secret" {
  name         = "ccd-gw-s2s-secret"
  value        = "${data.azurerm_key_vault_secret.ccd_gw_s2s_key.value}"
  key_vault_id = "${module.vault.key_vault_id}"
}

data "azurerm_key_vault_secret" "alert_ccd_email_secret" {
  name      = "ccd-alert-email"
  key_vault_id = "${module.vault.key_vault_id}"
}

output "vaultName" {
  value = "${module.vault.key_vault_name}"
}

output "vaultUri" {
  value = "${module.vault.key_vault_uri}"
}