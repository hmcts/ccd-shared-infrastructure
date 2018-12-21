data "azurerm_key_vault_secret" "cert" {
  name      = "${var.external_cert_name}"
  vault_uri = "${var.external_cert_vault_uri}"
}


module "appGw" {
  source            = "git@github.com:hmcts/cnp-module-waf?ref=stripDownWf"
  env               = "${var.env}"
  subscription      = "${var.subscription}"
  location          = "${var.location}"
  wafName           = "${var.product}-appGW"
  resourcegroupname = "${azurerm_resource_group.rg.name}"

  # vNet connections
  gatewayIpConfigurations = [
    {
      name     = "internalNetwork"
      subnetId = "${data.azurerm_subnet.main_subnet.id}"
    },
  ]

  sslCertificates = [
    {
      name     = "${var.external_cert_name}"
      data     = "${data.azurerm_key_vault_secret.cert.value}"
      password = ""
    },
  ]

  # Http Listeners
  httpListeners = [
    {
      name                    = "${var.product}-http-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort            = "frontendPort80"
      Protocol                = "Http"
      SslCertificate          = ""
      hostName                = "${var.external_hostname}"
    },
    {
      name                    = "https-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort            = "frontendPort443"
      Protocol                = "Https"
      SslCertificate          = "${var.external_cert_name}"
      hostName                = "${var.external_hostname}"
    },
  ]

  # Backend address Pools
  backendAddressPools = [
    {
      name = "${var.product}-${var.env}-palo_alto"
      backendAddresses = "${module.palo_alto.untrusted_ips_fqdn}"
    },
    {
      name = "${var.product}-${var.env}-backend-pool"
      backendAddresses = "${local.ccdgw_hostname}"
    }
  ]

  backendHttpSettingsCollection = [
    {
      name                           = "backend-80-nocookies"
      port                           = 80
      Protocol                       = "Http"
      AuthenticationCertificates     = ""
      CookieBasedAffinity            = "Disabled"
      probeEnabled                   = "True"
      probe                          = "http-probe"
      PickHostNameFromBackendAddress = "False"
      Host                           = "${var.external_hostname}"
    },
    {
      name                           = "backend-443-nocookies"
      port                           = 443
      Protocol                       = "Https"
      AuthenticationCertificates     = ""
      CookieBasedAffinity            = "Disabled"
      probeEnabled                   = "True"
      probe                          = "https-probe"
      PickHostNameFromBackendAddress = "True"
      Host                           = "${var.external_hostname}"
    }
  ]

  # Request routing rules
  requestRoutingRules = [
    {
      name                       = "https"
      rule_type                  = "Basic"
      http_listener_name         = "https-listener"
      backend_address_pool_name  = "${var.product}-${var.env}-backend-pool"
      backend_http_settings_name = "backend"
    },
    {
      name                       = "https"
      rule_type                  = "PathBasedRouting"
      http_listener_name         = "https-listener"
      backend_address_pool_name  = "${var.product}-${var.env}-palo-alto"
      backend_http_settings_name = "backend"
      url_path_map_name          = "/documents"
    }
  ]

  probes = [
    {
      name                                = "http-probe"
      protocol                            = "Http"
      path                                = "/"
      interval                            = "${var.health_check_interval}"
      timeout                             = "${var.health_check_timeout}"
      unhealthyThreshold                  = "${var.unhealthy_threshold}"
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings                 = "backend"
      host                                = "${var.external_hostname}"
      healthyStatusCodes                  = "200-404"                  // MS returns 400 on /, allowing more codes in case they change it
    },
    {
      name                                = "https-probe"
      protocol                            = "Https"
      path                                = "/"
      interval                            = "${var.health_check_interval}"
      timeout                             = "${var.health_check_timeout}"
      unhealthyThreshold                  = "${var.unhealthy_threshold}"
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings                 = "backend-443-nocookies"
      host                                = "${var.external_hostname}"
      healthyStatusCodes                  = "200-399"
    }
  ]
}

// As there is not support for redirecction rules in Azure for terraform yet. HTTPS is the only listener configured
// TODO ref:https://github.com/terraform-providers/terraform-provider-azurerm/issues/552#issuecomment-427295158
//resource "null_resource" "config_redirect_rule_http_to_https" {
//  provisioner "local-exec" {
//    command     = "az network application-gateway redirect-config create --gateway-name ${appGw.wafName} --name ${azurerm_virtual_network.k8s_vnet.name}-rcfg-http-to-https --resource-group ${azurerm_resource_group.rg.name} --type Permanent --target-listener ${azurerm_virtual_network.k8s_vnet.name}-httplstn-https"
//  }
//
//  lifecycle {
//    ignore_changes = ["provisioner"]
//  }
//}