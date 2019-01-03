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
      name                    = "${var.product}-http-listener-gateway"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort            = "frontendPort80"
      Protocol                = "Http"
      SslCertificate          = ""
      hostName                = "${var.external_hostname_gateway}"
    },
    {
      name                    = "${var.product}-https-listener-gateway"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort            = "frontendPort443"
      Protocol                = "Https"
      SslCertificate          = "${var.external_cert_name}"
      hostName                = "${var.external_hostname_gateway}"
    },
    {
      name                    = "${var.product}-http-listener-www"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort            = "frontendPort80"
      Protocol                = "Http"
      SslCertificate          = ""
      hostName                = "${var.external_hostname_www}"
    },
    {
      name                    = "${var.product}-https-listener-www"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort            = "frontendPort443"
      Protocol                = "Https"
      SslCertificate          = "${var.external_cert_name}"
      hostName                = "${var.external_hostname_www}"
    }
  ]

  # Backend address Pools
  backendAddressPools = [
    {
      name = "${var.product}-${var.env}-palo-alto"
      backendAddresses = "${module.palo_alto.untrusted_ips_fqdn}"
    },
    {
      name = "${var.product}-${var.env}-backend-pool"
      backendAddresses = "${var.ilbIp}"
    }
  ]

  backendHttpSettingsCollection = [
    {
      name                           = "backend-80-nocookies-gateway"
      port                           = 80
      Protocol                       = "Http"
      AuthenticationCertificates     = ""
      CookieBasedAffinity            = "Disabled"
      probeEnabled                   = "True"
      probe                          = "http-probe-gateway"
      PickHostNameFromBackendAddress = "False"
      Host                           = "${var.external_hostname_gateway}"
    },
    {
      name                           = "backend-443-nocookies-gateway"
      port                           = 443
      Protocol                       = "Https"
      AuthenticationCertificates     = ""
      CookieBasedAffinity            = "Disabled"
      probeEnabled                   = "True"
      probe                          = "https-probe-gateway"
      PickHostNameFromBackendAddress = "True"
      Host                           = "${var.external_hostname_gateway}"
    },
    {
      name                           = "backend-80-nocookies-www"
      port                           = 80
      Protocol                       = "Http"
      AuthenticationCertificates     = ""
      CookieBasedAffinity            = "Disabled"
      probeEnabled                   = "True"
      probe                          = "http-probe-www"
      PickHostNameFromBackendAddress = "False"
      Host                           = "${var.external_hostname_www}"
    },
    {
      name                           = "backend-443-nocookies-www"
      port                           = 443
      Protocol                       = "Https"
      AuthenticationCertificates     = ""
      CookieBasedAffinity            = "Disabled"
      probeEnabled                   = "True"
      probe                          = "https-probe-www"
      PickHostNameFromBackendAddress = "True"
      Host                           = "${var.external_hostname_www}"
    }
  ]

  # Request routing rules
  requestRoutingRules = [
    {
      name                       = "http-gateway"
      rule_type                  = "Basic"
      http_listener_name         = "${var.product}-http-listener-gateway"
      backend_address_pool_name  = "${var.product}-${var.env}-backend-pool"
      backend_http_settings_name = "backend-80-nocookies-gateway"
    },
    {
      name                       = "https-gateway"
      rule_type                  = "PathBasedRouting"
      http_listener_name         = "${var.product}-https-listener-gateway"
      url_path_map_name          = "https-url-path-map-gateway"
    },
    {
      name                       = "http-www"
      rule_type                  = "Basic"
      http_listener_name         = "${var.product}-http-listener-www"
      backend_address_pool_name  = "${var.product}-${var.env}-backend-pool"
      backend_http_settings_name = "backend-80-nocookies-www"
    },
    {
      name                       = "https-www"
      rule_type                  = "Basic"
      http_listener_name         = "${var.product}-https-listener-www"
      backend_address_pool_name  = "${var.product}-${var.env}-backend-pool"
      backend_http_settings_name = "backend-443-nocookies-www"
    }
  ]

  url_path_map = {
    name                               = "https-url-path-map-gateway"
    default_backend_address_pool_name  = "${var.product}-${var.env}-backend-pool"
    default_backend_http_settings_name = "backend-443-nocookies-gateway"
    path_rule = {
      name                       = "https-url-path-map-gateway-rule-palo-alto"
      paths                      = [ "/documents" ]
      backend_address_pool_name  = "${var.product}-${var.env}-palo-alto"
      backend_http_settings_name = "backend-443-nocookies-gateway"
    }

  }

  probes = [
    {
      name                                = "http-probe-gateway"
      protocol                            = "Http"
      path                                = "/"
      interval                            = "${var.health_check_interval}"
      timeout                             = "${var.health_check_timeout}"
      unhealthyThreshold                  = "${var.unhealthy_threshold}"
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings                 = "backend-80-nocookies-gateway"
      host                                = "${var.external_hostname_gateway}"
      healthyStatusCodes                  = "200-404"                  // MS returns 400 on /, allowing more codes in case they change it
    },
    {
      name                                = "https-probe-gateway"
      protocol                            = "Https"
      path                                = "/"
      interval                            = "${var.health_check_interval}"
      timeout                             = "${var.health_check_timeout}"
      unhealthyThreshold                  = "${var.unhealthy_threshold}"
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings                 = "backend-443-nocookies-gateway"
      host                                = "${var.external_hostname_gateway}"
      healthyStatusCodes                  = "200-399"
    },
    {
      name                                = "http-probe-www"
      protocol                            = "Http"
      path                                = "/"
      interval                            = "${var.health_check_interval}"
      timeout                             = "${var.health_check_timeout}"
      unhealthyThreshold                  = "${var.unhealthy_threshold}"
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings                 = "backend-80-nocookies-www"
      host                                = "${var.external_hostname_www}"
      healthyStatusCodes                  = "200-404"                  // MS returns 400 on /, allowing more codes in case they change it
    },
    {
      name                                = "https-probe-www"
      protocol                            = "Https"
      path                                = "/"
      interval                            = "${var.health_check_interval}"
      timeout                             = "${var.health_check_timeout}"
      unhealthyThreshold                  = "${var.unhealthy_threshold}"
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings                 = "backend-443-nocookies-www"
      host                                = "${var.external_hostname_www}"
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