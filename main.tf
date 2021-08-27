terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "1.6.0"
    }
  }
}
 
locals {
  tags = "${merge(
    var.common_tags,
    map(
      "Team Contact", var.team_contact,
      "Destroy Me", var.destroy_me
    )
  )}"
}

// Shared Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-shared-${var.env}"
  location = "${var.location}"

  tags = "${local.tags}"
}
