locals {
  ase_name = "core-compute-${var.env}"

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
