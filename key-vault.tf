module "vault" {
  source              = "git@github.com:hmcts/cnp-module-key-vault?ref=DTSPO-13637"
  name                = "ccd-${var.env}"
  product             = var.product
  env                 = var.env
  tenant_id           = var.tenant_id
  object_id           = var.jenkins_AAD_objectId
  resource_group_name = azurerm_resource_group.rg.name
  product_group_name  = "dcd_ccd"

  common_tags = local.tags

  managed_identity_object_id = var.managed_identity_object_id
  product_name               = var.product_name
  create_managed_identity    = true
}

data "azurerm_key_vault" "s2s_vault" {
  name                = "s2s-${var.env}"
  resource_group_name = "rpe-service-auth-provider-${var.env}"
}

data "azurerm_key_vault_secret" "ccd_gw_s2s_key" {
  name         = "microservicekey-ccd-gw"
  key_vault_id = data.azurerm_key_vault.s2s_vault.id
}
  
data "azurerm_key_vault_secret" "ccd_case_disposer_s2s_key" {
  name         = "microservicekey-ccd-case-disposer"
  key_vault_id = data.azurerm_key_vault.s2s_vault.id
}  

resource "azurerm_key_vault_secret" "ccd-case-disposer-s2s-secret" {
  name         = "ccd-case-disposer-s2s-secret"
  value        = data.azurerm_key_vault_secret.ccd_case_disposer_s2s_key.value
  key_vault_id = module.vault.key_vault_id
}  

resource "azurerm_key_vault_secret" "ccd_gw_s2s_secret" {
  name         = "ccd-gw-s2s-secret"
  value        = data.azurerm_key_vault_secret.ccd_gw_s2s_key.value
  key_vault_id = module.vault.key_vault_id
}

data "azurerm_key_vault_secret" "ccd_next_hearing_date_updater_s2s_key" {
  name         = "microservicekey-ccd-next-hearing-date-updater"
  key_vault_id = data.azurerm_key_vault.s2s_vault.id
}

resource "azurerm_key_vault_secret" "ccd-next-hearing-date-updater-s2s-secret" {
  name         = "ccd-next-hearing-date-updater-s2s-secret"
  value        = data.azurerm_key_vault_secret.ccd_next_hearing_date_updater_s2s_key.value
  key_vault_id = module.vault.key_vault_id
}

output "vaultName" {
  value = module.vault.key_vault_name
}

output "vaultUri" {
  value = module.vault.key_vault_uri
}
