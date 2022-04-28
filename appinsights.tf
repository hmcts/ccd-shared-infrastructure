resource "azurerm_application_insights" "appinsights" {
  name                = "${var.product}-${var.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = var.application_type
  tags                = var.common_tags

  lifecycle {
    ignore_changes = [
      # Ignore changes to appinsights as otherwise upgrading to the Azure provider 2.x
      # destroys and re-creates this appinsights instance
      application_type,
    ]
  }
}

output "appInsightsInstrumentationKey" {
  sensitive = true
  value     = azurerm_application_insights.appinsights.instrumentation_key
}

resource "azurerm_key_vault_secret" "app_insights_key" {
  name         = "AppInsightsInstrumentationKey"
  value        = azurerm_application_insights.appinsights.instrumentation_key
  key_vault_id = module.vault.key_vault_id
}
