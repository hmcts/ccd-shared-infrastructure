locals {
  ase_name = "core-compute-${var.env}"

  common_tags = {
    team_name    = "${var.team_name}"
    team_contact = "${var.team_contact}"
  }

  ccdgw_hostname = "gateway.${var.env}.platform.hmcts.net"
}

// Shared Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-shared-${var.env}"
  location = "${var.location}"

  tags {
    "Deployment Environment" = "${var.env}"
    "Team Name" = "${var.team_name}"
    "Team Contact" = "${var.team_contact}"
    "Destroy Me" = "${var.destroy_me}"
  }
}
