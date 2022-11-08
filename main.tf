locals {
  tags = merge(
    var.common_tags,
    tomap({
      "Team Contact" = var.team_contact
      "Destroy Me" = var.destroy_me
    })
  )
  em_tags = merge(
      var.common_tags,
      tomap({
        "Team Contact" = var.em_team_contact
        "Destroy Me" = var.em_destroy_me
      })
  )
}

// Shared Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-shared-${var.env}"
  location = var.location

  tags = local.tags
}
