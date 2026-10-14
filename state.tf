provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "aks-infra"
  subscription_id = var.aks_subscription_id
  features {}
  skip_provider_registration = true
}

provider "azurerm" {
  alias           = "aks-preview"
  subscription_id = "8b6ea922-0862-443e-af15-6056e1c9b9a4"
  features {}
}

provider "azurerm" {
  alias           = "aks_prod"
  subscription_id = "8cbc6f36-7c56-4963-9d36-739db5d00b27"
  features {}
}

provider "azurerm" {
  alias           = "mgmt"
  subscription_id = var.mgmt_subscription_id
  features {}
}

terraform {
  required_version = ">= 1.1.7" # Terraform client version

  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0" # AzureRM provider version
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.53.1"
    }
  }
}
