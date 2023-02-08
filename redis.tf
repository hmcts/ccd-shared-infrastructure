data "azurerm_subnet" "core_infra_redis_subnet" {
  name                 = "core-infra-subnet-1-${var.env}"
  virtual_network_name = "core-infra-vnet-${var.env}"
  resource_group_name  = "core-infra-${var.env}"
}

data "azurerm_subnet" "bastion-nonprod_redis_subnet" {
  name                 = "bastion-nonprod-vnet-redis"
  virtual_network_name = "bastion-nonprod-vnet"
  resource_group_name  = "bastion-nonprod-rg"
}

data "azurerm_key_vault" "shared" {
  name                = "ccd-${var.env}"
  resource_group_name = "ccd-shared-${var.env}"
}

resource "azurerm_key_vault_secret" "redis_connection_string" {
  name         = "ccd-redis-password"
  value        = module.redis-ccd.access_key
  key_vault_id = data.azurerm_key_vault.shared.id
}

module "redis-ccd" {
  source                        = "git@github.com:hmcts/cnp-module-redis?ref=master"
  product                       = "${var.product}-redis"
  location                      = var.location
  env                           = "${var.env}"
  subnetid                      = "${data.azurerm_subnet.core_infra_redis_subnet.id}"
  common_tags                   = "${var.common_tags}"
  redis_version                 = "6"
  business_area                 = "cft" # cft or sds
  private_endpoint_enabled      = true
  public_network_access_enabled = false
}