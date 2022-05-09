// Shared and specialised Storage Accounts

locals {
  mgmt_network_name    = "cft-ptl-vnet"
  mgmt_network_rg_name = "cft-ptl-network-rg"

  preview_vnet_name           = "core-preview-vnet"
  preview_vnet_resource_group = "aks-infra-preview-rg"
  aks_env                     = var.env == "sandbox" ? "sbox" : var.env

  app_aks_network_name    = "cft-${local.aks_env}-vnet"
  app_aks_network_rg_name = "cft-${local.aks_env}-network-rg"

  # currently live prod vNet, remove once arm -> terraform migration completed
  arm_based_prod_network_name = "core-prod-vnet"
  arm_based_prod_rg_name = "aks-infra-prod-rg"

  standard_subnets = [
    data.azurerm_subnet.jenkins_subnet.id,
    data.azurerm_subnet.jenkins_aks_00.id,
    data.azurerm_subnet.jenkins_aks_01.id,
    data.azurerm_subnet.app_aks_00_subnet.id,
    data.azurerm_subnet.app_aks_01_subnet.id
  ]

  preview_subnets = var.env == "aat" ? [data.azurerm_subnet.preview_aks_00_subnet.id, data.azurerm_subnet.preview_aks_01_subnet.id] : []
  prod_subnets = var.env == "prod" ? [data.azurerm_subnet.prod_aks_00_subnet[0].id, data.azurerm_subnet.prod_aks_01_subnet[0].id] : []
  valid_subnets   = concat(local.standard_subnets, local.preview_subnets, local.prod_subnets)
  
  dmstoredoc_storage_replication_type = var.env == "aat" ? "LRS" : "ZRS"
}

data "azurerm_subnet" "preview_aks_00_subnet" {
  provider             = azurerm.aks-preview
  name                 = "aks-00"
  virtual_network_name = local.preview_vnet_name
  resource_group_name  = local.preview_vnet_resource_group
}

data "azurerm_subnet" "preview_aks_01_subnet" {
  provider             = azurerm.aks-preview
  name                 = "aks-01"
  virtual_network_name = local.preview_vnet_name
  resource_group_name  = local.preview_vnet_resource_group
}

data "azurerm_subnet" "prod_aks_00_subnet" {
  count = var.env == "prod" ? 1 : 0

  provider             = azurerm.aks_prod
  name                 = "aks-00"
  virtual_network_name = local.arm_based_prod_network_name
  resource_group_name  = local.arm_based_prod_rg_name
}

data "azurerm_subnet" "prod_aks_01_subnet" {
  count = var.env == "prod" ? 1 : 0

  provider             = azurerm.aks_prod
  name                 = "aks-01"
  virtual_network_name = local.arm_based_prod_network_name
  resource_group_name  = local.arm_based_prod_rg_name
}

data "azurerm_subnet" "jenkins_subnet" {
  provider             = azurerm.mgmt
  name                 = "iaas"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_subnet" "jenkins_aks_00" {
  provider             = azurerm.mgmt
  name                 = "aks-00"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_subnet" "jenkins_aks_01" {
  provider             = azurerm.mgmt
  name                 = "aks-01"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_subnet" "app_aks_00_subnet" {
  provider             = azurerm.aks-infra
  name                 = "aks-00"
  virtual_network_name = local.app_aks_network_name
  resource_group_name  = local.app_aks_network_rg_name
}

data "azurerm_subnet" "app_aks_01_subnet" {
  provider             = azurerm.aks-infra
  name                 = "aks-01"
  virtual_network_name = local.app_aks_network_name
  resource_group_name  = local.app_aks_network_rg_name
}


// Shared Storage Account
module "storage_account" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                      = var.env
  storage_account_name     = "${var.product}shared${var.env}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  access_tier              = "Hot"

  enable_https_traffic_only = true

  sa_subnets = local.valid_subnets

  #   Temporarily disabling and relying on Portal settings, to enable successful TF apply https://tools.hmcts.net/confluence/display/CCD/CCD+Storage+Accounts+Update+Blocked+-+Program+Decision+Required
  #   enable_data_protection = var.ccd_storage_account_enable_data_protection

  // Tags
  common_tags  = local.tags
  team_contact = var.team_contact
  destroy_me   = var.destroy_me
}


// Storage Account Vault Secrets
resource "azurerm_key_vault_secret" "storageaccount_id" {
  depends_on   = [module.vault]
  name         = "storage-account-id"
  value        = module.storage_account.storageaccount_id
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "storageaccount_primary_access_key" {
  depends_on   = [module.vault]
  name         = "storage-account-primary-access-key"
  value        = module.storage_account.storageaccount_primary_access_key
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "storageaccount_secondary_access_key" {
  depends_on   = [module.vault]
  name         = "storage-account-secondary-access-key"
  value        = module.storage_account.storageaccount_secondary_access_key
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "storageaccount_primary_connection_string" {
  depends_on   = [module.vault]
  name         = "storage-account-primary-connection-string"
  value        = module.storage_account.storageaccount_primary_connection_string
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "storageaccount_secondary_connection_string" {
  depends_on   = [module.vault]
  name         = "storage-account-secondary-connection-string"
  value        = module.storage_account.storageaccount_secondary_connection_string
  key_vault_id = module.vault.key_vault_id
}


output "storage_account_name" {
  value = module.storage_account.storageaccount_name
}


// dm-store blob Storage Account
module "dm_store_storage_account" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                      = var.env
  storage_account_name     = "dmstoredoc${var.env}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = local.dmstoredoc_storage_replication_type
  access_tier              = "Hot"

  enable_https_traffic_only = true

  sa_subnets = local.valid_subnets

  #   Temporarily disabling and relying on Portal settings, to enable successful TF apply https://tools.hmcts.net/confluence/display/CCD/CCD+Storage+Accounts+Update+Blocked+-+Program+Decision+Required
  #   enable_data_protection = var.ccd_storage_account_enable_data_protection

  // Tags
  common_tags  = local.tags
  team_contact = var.team_contact
  destroy_me   = var.destroy_me
}


// dm-store blob Storage Account Vault Secrets
resource "azurerm_key_vault_secret" "dm_store_storageaccount_id" {
  depends_on   = [module.vault]
  name         = "dm-store-storage-account-id"
  value        = module.dm_store_storage_account.storageaccount_id
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "dm_store_storageaccount_primary_access_key" {
  depends_on   = [module.vault]
  name         = "dm-store-storage-account-primary-access-key"
  value        = module.dm_store_storage_account.storageaccount_primary_access_key
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "dm_store_storageaccount_secondary_access_key" {
  depends_on   = [module.vault]
  name         = "dm-store-storage-account-secondary-access-key"
  value        = module.dm_store_storage_account.storageaccount_secondary_access_key
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "dm_store_storageaccount_primary_connection_string" {
  depends_on   = [module.vault]
  name         = "dm-store-storage-account-primary-connection-string"
  value        = module.dm_store_storage_account.storageaccount_primary_connection_string
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "dm_store_storageaccount_secondary_connection_string" {
  depends_on   = [module.vault]
  name         = "dm-store-storage-account-secondary-connection-string"
  value        = module.dm_store_storage_account.storageaccount_secondary_connection_string
  key_vault_id = module.vault.key_vault_id
}


output "dm_store_storage_account_name" {
  value = module.dm_store_storage_account.storageaccount_name
}
