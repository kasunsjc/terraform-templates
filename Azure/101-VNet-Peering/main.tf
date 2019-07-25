#Provider
provider "azurerm" {
  
}

#Create a Resource Group

resource "azurerm_resource_group" "peering-rg" {
  name = "${var.rg_name}"
  location = "${var.location}"
}

#Create First Virtual Network
resource "azurerm_virtual_network" "vnet-01" {
  address_space = ["${var.network1_address_space}"]
  location = "${azurerm_resource_group.peering-rg.location}"
  resource_group_name = "${azurerm_resource_group.peering-rg.name}"
  name = "${var.vnet1_name}"
  tags = {
      Deployment = "Peering"
  }

  subnet{
    name = "${var.vnet1_subnet1_name}"
    address_prefix = "${var.vnet1_subnet1_address_prefix}"
  }

  subnet{
    name = "${var.vnet1_subnet2_name}"
    address_prefix = "${var.vnet1_subnet2_address_prefix}"
  }
}

#Create Second Virtual Network
resource "azurerm_virtual_network" "vnet-02" {
  address_space = ["${var.network2_address_space}"]
  location = "${azurerm_resource_group.peering-rg.location}"
  resource_group_name = "${azurerm_resource_group.peering-rg.name}"
  name = "${var.vnet2_name}"
  tags = {
      Deployment = "Peering"
  }

  subnet{
    name = "${var.vnet2_subnet1_name}"
    address_prefix = "${var.vnet2_subnet1_address_prefix}"
  }

  subnet{
    name = "${var.vnet2_subnet2_name}"
    address_prefix = "${var.vnet2_subnet2_address_prefix}"
  }
}

#Peering Connection

resource "azurerm_virtual_network_peering" "peering-01" {
  resource_group_name = "${azurerm_resource_group.peering-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet-01.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.vnet-02.id}"
  name = "VNet1-Peering"
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "peering-02" {
  resource_group_name = "${azurerm_resource_group.peering-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet-02.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.vnet-01.id}"
  name = "VNet2-Peering"
  allow_virtual_network_access = true
  allow_forwarded_traffic = true

}

