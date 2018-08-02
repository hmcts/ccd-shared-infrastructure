resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-shared-${var.env}"
  location = "${var.location}"
}
