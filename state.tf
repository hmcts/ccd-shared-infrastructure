provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "aks-infra"
  subscription_id = "${var.aks_infra_subscription_id}"
  features {}
  skip_provider_registration = true
}

provider "azurerm" {
  alias           = "aks-preview"
  subscription_id = "${var.aks_preview_subscription_id}"
  features {}
}

provider "azurerm" {
  alias           = "mgmt"
  subscription_id = "${var.mgmt_subscription_id}"
  features {}
}

terraform {
  required_version = ">= 0.13"  # Terraform client version

  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.50.0"       # AzureRM provider version
    }
  }
}
