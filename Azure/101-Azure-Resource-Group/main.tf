provider "azurerm" {
  features {}
  version = "~>2.00"
}
resource "azurerm_resource_group" "rg" {
  name = "TFResourceGroup"
  location = "centralus"
}