// Shared and specialised Storage Accounts


// Shared Storage Account
module "storage_account" {
  source                    = "git@github.com:hmcts/cnp-module-storage-account.git?ref=azurermv2"
  env                       = "${var.env}"
  storage_account_name      = "${var.product}shared${var.env}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  location                  = "${var.location}"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier               = "Hot"

  enable_https_traffic_only = true

  // Tags
  common_tags  = "${local.tags}"
  team_contact = "${var.team_contact}"
  destroy_me   = "${var.destroy_me}"
}


// Storage Account Vault Secrets
resource "azurerm_key_vault_secret" "storageaccount_id" {
  depends_on = ["module.vault"]
  name      = "storage-account-id"
  value     = "${module.storage_account.storageaccount_id}"
  key_vault_id = "${module.vault.key_vault_id}"
}

resource "azurerm_key_vault_secret" "storageaccount_primary_access_key" {
  depends_on = ["module.vault"]
  name      = "storage-account-primary-access-key"
  value     = "${module.storage_account.storageaccount_primary_access_key}"
  key_vault_id = "${module.vault.key_vault_id}"
}

resource "azurerm_key_vault_secret" "storageaccount_secondary_access_key" {
  depends_on = ["module.vault"]
  name      = "storage-account-secondary-access-key"
  value     = "${module.storage_account.storageaccount_secondary_access_key}"
  key_vault_id = "${module.vault.key_vault_id}"
}

resource "azurerm_key_vault_secret" "storageaccount_primary_connection_string" {
  depends_on = ["module.vault"]
  name      = "storage-account-primary-connection-string"
  value     = "${module.storage_account.storageaccount_primary_connection_string}"
  key_vault_id = "${module.vault.key_vault_id}"
}

resource "azurerm_key_vault_secret" "storageaccount_secondary_connection_string" {
  depends_on = ["module.vault"]
  name      = "storage-account-secondary-connection-string"
  value     = "${module.storage_account.storageaccount_secondary_connection_string}"
  key_vault_id = "${module.vault.key_vault_id}"
}


output "storage_account_name" {
  value = "${module.storage_account.storageaccount_name}"
}


// dm-store blob Storage Account
module "dm_store_storage_account" {
  source                    = "git@github.com:hmcts/cnp-module-storage-account.git?ref=azurermv2"
  env                       = "${var.env}"
  storage_account_name      = "dmstoredoc${var.env}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  location                  = "${var.location}"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier               = "Hot"

  enable_https_traffic_only = true

  // Tags
  common_tags  = "${local.tags}"
  team_contact = "${var.team_contact}"
  destroy_me   = "${var.destroy_me}"
}


// dm-store blob Storage Account Vault Secrets
resource "azurerm_key_vault_secret" "dm_store_storageaccount_id" {
  depends_on = ["module.vault"]
  name      = "dm-store-storage-account-id"
  value     = "${module.dm_store_storage_account.storageaccount_id}"
  key_vault_id = "${module.vault.key_vault_id}"
}

resource "azurerm_key_vault_secret" "dm_store_storageaccount_primary_access_key" {
  depends_on = ["module.vault"]
  name      = "dm-store-storage-account-primary-access-key"
  value     = "${module.dm_store_storage_account.storageaccount_primary_access_key}"
  key_vault_id = "${module.vault.key_vault_id}"
}

resource "azurerm_key_vault_secret" "dm_store_storageaccount_secondary_access_key" {
  depends_on = ["module.vault"]
  name      = "dm-store-storage-account-secondary-access-key"
  value     = "${module.dm_store_storage_account.storageaccount_secondary_access_key}"
  key_vault_id = "${module.vault.key_vault_id}"
}

resource "azurerm_key_vault_secret" "dm_store_storageaccount_primary_connection_string" {
  depends_on = ["module.vault"]
  name      = "dm-store-storage-account-primary-connection-string"
  value     = "${module.dm_store_storage_account.storageaccount_primary_connection_string}"
  key_vault_id = "${module.vault.key_vault_id}"
}

resource "azurerm_key_vault_secret" "dm_store_storageaccount_secondary_connection_string" {
  depends_on = ["module.vault"]
  name      = "dm-store-storage-account-secondary-connection-string"
  value     = "${module.dm_store_storage_account.storageaccount_secondary_connection_string}"
  key_vault_id = "${module.vault.key_vault_id}"
}


output "dm_store_storage_account_name" {
  value = "${module.dm_store_storage_account.storageaccount_name}"
}
