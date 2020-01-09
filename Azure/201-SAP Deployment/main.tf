resource "azurerm_resource_group" "default" {
  name     = var.namespace
  location = var.region
}

resource "azurerm_resource_group" "sap-deploy-rg" {
  name = var.resourceGroup_name
  location = var.location
}