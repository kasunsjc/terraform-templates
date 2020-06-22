provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "vnet_rg" {
  location = var.region
  name = var.vnet_rg
}

resource "azurerm_virtual_network" "vnet" {
  address_space = [var.vnet_cidr]
  location = azurerm_resource_group.vnet_rg.location
  name = var.vnet_name
  resource_group_name = azurerm_resource_group.vnet_rg.name
}

resource "azurerm_subnet" "frontend_subnet" {
  name = var.frontend_subnet_name
  resource_group_name = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.frontend_subnet_cidr]
}

resource "azurerm_subnet" "backend_subnet" {
  name = var.backend_subnet_name
  resource_group_name = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.backend_subnet_cidr]
}