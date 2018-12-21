module "storage_account" {
  source                    = "git@github.com:hmcts/cnp-module-storage-account.git?ref=0.0.1"
  env                       = "${var.env}"
  storage_account_name      = "${var.product}shared${var.env}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  location                  = "${var.location}"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier               = "Hot"

  enable_blob_encryption    = true
  enable_file_encryption    = true
  enable_https_traffic_only = true

  // Tags
  common_tags  = "${local.tags}"
  team_contact = "${var.team_contact}"
  destroy_me   = "${var.destroy_me}"
}


// Storage Account Vault Secrets
resource "azurerm_key_vault_secret" "storageaccount_id" {
  name      = "storage-account-id"
  value     = "${module.storage_account.storageaccount_id}"
  vault_uri = "${module.vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "storageaccount_primary_access_key" {
  name      = "storage-account-primary-access-key"
  value     = "${module.storage_account.storageaccount_primary_access_key}"
  vault_uri = "${module.vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "storageaccount_secondary_access_key" {
  name      = "storage-account-secondary-access-key"
  value     = "${module.storage_account.storageaccount_secondary_access_key}"
  vault_uri = "${module.vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "storageaccount_primary_connection_string" {
  name      = "storage-account-primary-connection-string"
  value     = "${module.storage_account.storageaccount_primary_connection_string}"
  vault_uri = "${module.vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "storageaccount_secondary_connection_string" {
  name      = "storage-account-secondary-connection-string"
  value     = "${module.storage_account.storageaccount_secondary_connection_string}"
  vault_uri = "${module.vault.key_vault_uri}"
}


output "storage_account_name" {
  value = "${module.storage_account.storageaccount_name}"
}


// dm-store blob Storage Account
module "dm_store_storage_account" {
  source                    = "git@github.com:hmcts/cnp-module-storage-account.git?ref=0.0.1"
  env                       = "${var.env}"
  storage_account_name      = "dmstoredoc${var.env}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  location                  = "${var.location}"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier               = "Hot"

  enable_blob_encryption    = true
  enable_file_encryption    = true
  enable_https_traffic_only = true

  // Tags
  common_tags  = "${local.tags}"
  team_contact = "${var.team_contact}"
  destroy_me   = "${var.destroy_me}"
}


// dm-store blob Storage Account Vault Secrets
resource "azurerm_key_vault_secret" "dm_store_storageaccount_id" {
  name      = "dm-store-storage-account-id"
  value     = "${module.dm_store_storage_account.storageaccount_id}"
  vault_uri = "${module.vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "dm_store_storageaccount_primary_access_key" {
  name      = "dm-store-storage-account-primary-access-key"
  value     = "${module.dm_store_storage_account.storageaccount_primary_access_key}"
  vault_uri = "${module.vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "dm_store_storageaccount_secondary_access_key" {
  name      = "dm-store-storage-account-secondary-access-key"
  value     = "${module.dm_store_storage_account.storageaccount_secondary_access_key}"
  vault_uri = "${module.vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "dm_store_storageaccount_primary_connection_string" {
  name      = "dm-store-storage-account-primary-connection-string"
  value     = "${module.dm_store_storage_account.storageaccount_primary_connection_string}"
  vault_uri = "${module.vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "dm_store_storageaccount_secondary_connection_string" {
  name      = "dm-store-storage-account-secondary-connection-string"
  value     = "${module.dm_store_storage_account.storageaccount_secondary_connection_string}"
  vault_uri = "${module.vault.key_vault_uri}"
}


output "dm_store_storage_account_name" {
  value = "${module.dm_store_storage_account.storageaccount_name}"
}
