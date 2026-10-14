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
  alias                           = "aks-preview"
  subscription_id                 = var.env == "aat" ? var.aks_preview_subscription_id : var.aks_subscription_id
  resource_provider_registrations = "none"
  features {}
}

provider "azurerm" {
  alias                           = "cnp_dev"
  subscription_id                 = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
  resource_provider_registrations = "none"
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
