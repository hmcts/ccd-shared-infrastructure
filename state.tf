terraform {
 backend "azurerm" {}
}

provider "azurerm" {
  version = "2.42.0"
  features {}
}
