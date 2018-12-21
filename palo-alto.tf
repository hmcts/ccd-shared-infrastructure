module "palo_alto" {
  source       = "git@github.com:hmcts/cnp-module-palo-alto.git"
  subscription = "${var.subscription}"
  env          = "${var.env}"
  product      = "${var.product}"

  untrusted_vnet_name           = "core-infra-vnet-${var.env}"
  untrusted_vnet_resource_group = "core-infra-${var.env}"
  untrusted_vnet_subnet_name    = "palo-untrusted"
  trusted_vnet_name             = "core-infra-vnet-${var.env}"
  trusted_vnet_resource_group   = "core-infra-${var.env}"
  trusted_vnet_subnet_name      = "palo-trusted"
  trusted_destination_ip        = "${local.ccdgw_hostname}"
}

module "ase_internal_ip" {
  source     = "git@github.com:matti/terraform-shell-outputs?ref=v0.1.2"
  command = "az resource show --ids '/subscriptions/${var.subscription}/resourceGroups/${local.ase_name}/providers/Microsoft.Web/hostingEnvironments/${local.ase_name}/capacities/virtualip' --query 'internalIpAddress'"
}
