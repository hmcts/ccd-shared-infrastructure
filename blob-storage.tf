resource "azurerm_storage_account" "storage" {
  name = "dm-store-blob${var.env}"
  resource_group_name = "${var.product}-shared-${var.env}"
  location = "${var.location}"
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage" {
  name = "blob-storage"
  resource_group_name = "${var.product}-shared-${var.env}"
  storage_account_name = "${azurerm_storage_account.storage.name}"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "storage" {
  name = "blob-storage.vhd"

  resource_group_name = "${var.product}-shared-${var.env}"
  storage_account_name = "${azurerm_storage_account.storage.name}"
  storage_container_name = "${azurerm_storage_container.storage.name}"

  type = "page"
  size = 10240
}