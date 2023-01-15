# Static public ip

resource "azurerm_public_ip" "app_gw_public_ip" {
  name                = format("%s-%s", var.environment_name, "PublicIP_ApplicationGateway")
  location            = var.location
  sku                 = var.sku_type
  resource_group_name = var.resource_group
  allocation_method   = var.ip_allocation_method
  ip_version          = var.public_ip_version
}

#----------------------------
# Application Gateway
#----------------------------

resource "azurerm_application_gateway" "az_application_gateway" {
  name                = "${var.gateway_configuration_prefix}-${var.app_gateway_name}"
  resource_group_name = var.resource_group
  location            = var.location

  frontend_ip_configuration {
    name                 = "${var.gateway_configuration_prefix}-fe-ip-config-public"
    public_ip_address_id = azurerm_public_ip.app_gw_public_ip.id
  }

  frontend_port {
    name = "${var.gateway_configuration_prefix}-fe-port-80"
    port = "80"
  }

  gateway_ip_configuration {
    name      = "${var.gateway_configuration_prefix}-gw-ip-config-1"
    subnet_id = var.web_subnet_id
  }

  backend_http_settings {
    name                  = "${var.gateway_configuration_prefix}-be-http-80"
    cookie_based_affinity = "Disabled"
    port                  = "80"
    protocol              = "HTTP"
    request_timeout       = "50"
  }

  http_listener {
    name                           = "${var.gateway_configuration_prefix}-http-listener-80"
    frontend_ip_configuration_name = "${var.gateway_configuration_prefix}-fe-ip-config-public"
    frontend_port_name             = "${var.gateway_configuration_prefix}-fe-port-80"
    protocol                       = "HTTP"
  }

  backend_address_pool {
    name = "${var.gateway_configuration_prefix}-be-address-pool"
  }


  # Request routing rule
  request_routing_rule {
    name                       = "${var.gateway_configuration_prefix}-route-rule-80"
    rule_type                  = "Basic"
    http_listener_name         = "${var.gateway_configuration_prefix}-http-listener-80"
    backend_http_settings_name = "${var.gateway_configuration_prefix}-be-http-80"
    backend_address_pool_name  = "${var.gateway_configuration_prefix}-be-address-pool"
  }

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = "2"
  }

  lifecycle {
    ignore_changes = all
  }
}