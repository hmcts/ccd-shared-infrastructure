module "adf" {
  source = "git@github.com:hmcts/cnp-module-adf?ref=master"
  data_factory_name_resource_group_name = "${azurerm_resource_group.rg.name}"
  data_factory_name = "${var.product}shared${var.env}"
  input_storage_account_resource_group_name = "${azurerm_resource_group.rg.name}"
  input_storage_account_name = module.storage_account.storageaccount_name
  output_storage_account_resource_group_name = "${azurerm_resource_group.rg.name}"
  output_storage_account_name = module.storage_account.storageaccount_name
  input_blob_container = "${var.product}-definition-store-api-imports-${var.env}"
  output_blob_container = "incremental-backup"
  input_storage_account_access_key = module.storage_account.storageaccount_primary_access_key
  output_storage_account_access_key = module.storage_account.storageaccount_primary_access_key
}