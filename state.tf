terraform {
  backend "azurerm" {}
}

data "azurerm_subnet" "main_subnet" {
  name                 = "core-infra-subnet-0-${var.env}"
  virtual_network_name = "core-infra-vnet-${var.env}"
  resource_group_name  = "core-infra-${var.env}"
}
