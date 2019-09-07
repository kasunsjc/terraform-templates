#Provider
/*
*Author - Kasun Rajapakse
*Subject - Enable vNet Peering
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

