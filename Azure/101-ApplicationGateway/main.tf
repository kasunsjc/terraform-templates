/*
*Author - Kasun Rajapakse
*Subject - Azure Recovery Vault 
*Language - HCL 
! Last Modify Date - Sep 7 2019
! Disclaimer- EGAL DISCLAIMER
This Sample Code is provided for the purpose of illustration only and is not
intended to be used in a production environment.  THIS SAMPLE CODE AND ANY
RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  We grant You a
nonexclusive, royalty-free right to use and modify the Sample Code and to
reproduce and distribute the object code form of the Sample Code, provided
that You agree: (i) to not use Our name, logo, or trademarks to market Your
software product in which the Sample Code is embedded; (ii) to include a valid
copyright notice on Your software product in which the Sample Code is embedded;
and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and
against any claims or lawsuits, including attorneys’ fees, that arise or result
from the use or distribution of the Sample Code. 
*/

provider "azurerm" {

}

#START Azure RM Resource Group
resource "azurerm_resource_group" "App-GW-RG" {
  name = "${var.rg_name}"
  location = "${var.location}"
}
#END Azure RM Resource Group

#START Virtual Network
resource "azurerm_virtual_network" "appgw_vnet" {
  name = "${var.vnet_name}"
  address_space = ["${var.network_address_space}"]
  location = "${azurerm_resource_group.App-GW-RG.location}"
  resource_group_name = "${azurerm_resource_group.App-GW-RG.name}"
}

resource "azurerm_subnet" "app-gw-subnet" {
  name = "${var.appgw_subnet_name}"
  address_prefix = "${var.appgw_subnet_address_prefix}"
  virtual_network_name = "${azurerm_virtual_network.appgw_vnet.name}"
  resource_group_name = "${azurerm_resource_group.App-GW-RG.name}"
}

resource "azurerm_subnet" "web-subnet" {
  name = "${var.web_subnet_name}"
  address_prefix = "${var.web_subnet_address_prefix}"
  virtual_network_name = "${azurerm_virtual_network.appgw_vnet.name}"
  resource_group_name = "${azurerm_resource_group.App-GW-RG.name}"
}



#Public IP Resources
resource "azurerm_public_ip" "app-gw-pip" {
  name = "${var.app_gw_pip}"
  resource_group_name = "${azurerm_resource_group.App-GW-RG.name}"
  location = "${azurerm_resource_group.App-GW-RG.location}"
  allocation_method = "Dynamic"
}


#locals for the App-GW
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.appgw_vnet.name}-backpool"
  frontend_port_name             = "${azurerm_virtual_network.appgw_vnet.name}-frontport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.appgw_vnet.name}-frondip"
  http_setting_name              = "${azurerm_virtual_network.appgw_vnet.name}-backend-http"
  listener_name                  = "${azurerm_virtual_network.appgw_vnet.name}-http-listen"
  request_routing_rule_name      = "${azurerm_virtual_network.appgw_vnet.name}-request-route-rule"
  redirect_configuration_name    = "${azurerm_virtual_network.appgw_vnet.name}-redirect-config-name"
}

#END Virtual Network

#START Azure Application Gateway
resource "azurerm_application_gateway" "App-GW" {
  name = "${var.app_gw_name}"
  location = "${azurerm_resource_group.App-GW-RG.location}"
  resource_group_name = "${azurerm_resource_group.App-GW-RG.name}"

 sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "app-gateway-ip-configuration"
    subnet_id = "${azurerm_subnet.app-gw-subnet.id}"
  }

  frontend_port {
    name = "${local.frontend_port_name}"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name}"
    public_ip_address_id = "${azurerm_public_ip.app-gw-pip.id}"
  }

  backend_address_pool {
    name = "${local.backend_address_pool_name}"
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}"
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = "${local.listener_name}"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
    frontend_port_name             = "${local.frontend_port_name}"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${local.request_routing_rule_name}"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name}"
    backend_address_pool_name  = "${local.backend_address_pool_name}"
    backend_http_settings_name = "${local.http_setting_name}"
  }
}
#END Azure Application Gateway
