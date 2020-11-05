locals {
  events_topic_name         = "${var.product}-events-topic-${var.env}"
  servicebus_namespace_name = "${var.product}-servicebus-${var.env}"
  resource_group_name       = azurerm_resource_group.rg.name
}

module "servicebus-namespace" {
#   source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  source              = "git@github.com:nathan-clark/terraform-module-servicebus-namespace?ref=patch-2"
  name                = local.servicebus_namespace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  env                 = var.env
  common_tags         = local.tags
  sku                 = "Premium"
  zoneRedundant       = true
}

module "events-topic" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=master"
  name                = local.events_topic_name 
  namespace_name      = local.servicebus_namespace_name
  resource_group_name = local.resource_group_name
}
