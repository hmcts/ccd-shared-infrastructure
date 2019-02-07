module "palo_alto" {
  source       = "git@github.com:hmcts/cnp-module-palo-alto.git"
  subscription = "${var.subscription}"
  env          = "${var.env}"
  product      = "${var.product}"
  common_tags  = "${local.tags}"

  untrusted_vnet_name           = "core-infra-vnet-${var.env}"
  untrusted_vnet_resource_group = "core-infra-${var.env}"
  untrusted_vnet_subnet_name    = "palo-untrusted"
  trusted_vnet_name             = "core-infra-vnet-${var.env}"
  trusted_vnet_resource_group   = "core-infra-${var.env}"
  trusted_vnet_subnet_name      = "palo-trusted"
  trusted_destination_ip        = "${var.ilbIp}"
}
