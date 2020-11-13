locals {
  events_topic_name         = "${var.product}-case-events-${var.env}"
  servicebus_namespace_name = "${var.product}-servicebus-${var.env}"
  resource_group_name       = azurerm_resource_group.rg.name
}

module "servicebus-namespace" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = local.servicebus_namespace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  env                 = var.env
  common_tags         = local.tags
  sku                 = var.sku
  zoneRedundant       = (var.sku != "Premium" ? "false" : "true")
}

module "events-topic" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=master"
  name                = local.events_topic_name
  namespace_name      = module.servicebus-namespace.name
  resource_group_name = local.resource_group_name
}
