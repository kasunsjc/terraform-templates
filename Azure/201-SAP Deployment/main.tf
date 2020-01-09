#Create Resource Group 

resource "azurerm_resource_group" "sap-deploy-rg" {
  name = var.resourceGroup_name
  location = var.location
}