provider "azurerm" {
  version = "=1.31.0"
}

resource "azurerm_resource_group" "AzureVMRG" {
  name     = "${var.rg-name}"
  location = "${var.location}"

  tags = {
    Deployed = "Terrraform"
  }
}

resource "azurerm_virtual_network" "VMvnet" {
  resource_group_name = "${azurerm_resource_group.AzureVMRG.name}"
  location            = "${azurerm_resource_group.AzureVMRG.location}"
  address_space       = ["${var.vnet_cidr}"]
  name                = "${var.network_name}"
  tags = {
    Deployed = "Terrraform"
  }
}

resource "azurerm_subnet" "VMvnet_subnet" {
  name                 = "${var.subnet_name}"
  address_prefix       = "${var.subnet_cidr}"
  resource_group_name  = "${azurerm_resource_group.AzureVMRG.name}"
  virtual_network_name = "${azurerm_virtual_network.VMvnet.name}"
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.prefix}-TFPIP"
  location            = "${azurerm_resource_group.AzureVMRG.location}"
  resource_group_name = "${azurerm_resource_group.AzureVMRG.name}"
  tags = {
    Deployed = "Terrraform"
  }

}
