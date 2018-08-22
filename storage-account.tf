resource "azurerm_storage_account" "storage" {
  name = "${var.product}store${var.env}"
  resource_group_name = "${var.product}-shared-${var.env}"
  location = "${var.location}"
  account_tier = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"

  tags {
    environment = "${var.env}"
  }
}

output "storageAccountName" {
  value = "${azurerm_storage_account.storage.name}"
}
