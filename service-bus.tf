locals {
  events_topic_name = "${var.product}-case-events-${var.env}"
  service_bus = {
    standard = {
      namespace_name = "${var.product}-servicebus-${var.env}"
      sku                       = "Standard"
    }
    premium = {
      namespace_name = "${var.product}-servicebus-${var.env}-premium"
      sku                       = "Premium"
    }
  }
  resource_group_name = azurerm_resource_group.rg.name
}

module "servicebus-namespace" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = local.service_bus.standard.namespace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  env                 = var.env
  common_tags         = local.tags
  sku                 = local.service_bus.standard.sku
  zoneRedundant       = (local.service_bus.standard.sku != "Premium" ? "false" : "true")
}

module "servicebus-namespace-premium" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = local.service_bus.premium.namespace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  env                 = var.env
  common_tags         = local.tags
  sku                 = local.service_bus.premium.sku
  zoneRedundant       = (local.service_bus.premium.sku != "Premium" ? "false" : "true")
}

module "events-topic" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=master"
  name                = local.events_topic_name
  namespace_name      = module.servicebus-namespace.name
  resource_group_name = local.resource_group_name
}

module "events-topic-premium" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=master"
  name                = local.events_topic_name
  namespace_name      = module.servicebus-namespace-premium.name
  resource_group_name = local.resource_group_name
}
