locals {
  events_topic_name         = "${var.product}-case-events-${var.env}"
  servicebus_namespace_name = "${var.product}-servicebus-${var.env}"
  resource_group_name       = azurerm_resource_group.rg.name
}

module "servicebus-namespace" {
  providers = {
    azurerm.private_endpoint = azurerm.aks-infra
  }
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=4.x"
  name                = local.servicebus_namespace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  env                 = var.env
  common_tags         = local.tags
  sku                 = var.sku
  zone_redundant      = var.sku != "Premium" ? "false" : "true"
}

module "events-topic" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=master"
  name                = local.events_topic_name
  namespace_name      = module.servicebus-namespace.name
  resource_group_name = local.resource_group_name
}

resource "azurerm_key_vault_secret" "servicebus_primary_connection_string" {
  name         = "ccd-servicebus-connection-string"
  value        = module.servicebus-namespace.primary_send_and_listen_connection_string
  key_vault_id = module.vault.key_vault_id
}
