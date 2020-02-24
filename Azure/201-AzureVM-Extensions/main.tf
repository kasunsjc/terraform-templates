/*
*Author - Kasun Rajapakse
*Subject - VM with Extensions
*Language - HCL 
! Last Modify Date - Sep 29 2019
! Disclaimer- LEGAL DISCLAIMER
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

#Provider

provider "azurerm" {
  
}

#Create Resource Group
resource "azurerm_resource_group" "AzureVMRG" {
  name     = "${var.rg-name}"
  location = "${var.location}"

  tags = {
    Deployed = "Terrraform"
  }
}

#Create Virtual Network
resource "azurerm_virtual_network" "VMvnet" {
  resource_group_name = "${azurerm_resource_group.AzureVMRG.name}"
  location            = "${azurerm_resource_group.AzureVMRG.location}"
  address_space       = ["${var.vnet_cidr}"]
  name                = "${var.network_name}"
  tags = {
    Deployed = "Terrraform"
  }
}

#Subnets
resource "azurerm_subnet" "VMvnet_subnet" {
  name                 = "${var.subnet_name}"
  address_prefix       = "${var.subnet_cidr}"
  resource_group_name  = "${azurerm_resource_group.AzureVMRG.name}"
  virtual_network_name = "${azurerm_virtual_network.VMvnet.name}"
}

#Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.prefix}-TFPIP"
  location            = "${azurerm_resource_group.AzureVMRG.location}"
  resource_group_name = "${azurerm_resource_group.AzureVMRG.name}"
  allocation_method   = "Dynamic"
  tags = {
    Deployed = "Terrraform"
  }

}

#NSG
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-NSG"
  resource_group_name = "${azurerm_resource_group.AzureVMRG.name}"
  location            = "${azurerm_resource_group.AzureVMRG.location}"
  tags = {
    Deployed = "Terrraform"
  }

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#VM NIC
resource "azurerm_network_interface" "nic" {
  name                      = "${var.prefix}-nic"
  location                  = "${azurerm_resource_group.AzureVMRG.location}"
  resource_group_name       = "${azurerm_resource_group.AzureVMRG.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
  tags = {
    Deployed = "Terrraform"
  }
  ip_configuration {
    name                          = "${var.prefix}-nic-config"
    subnet_id                     = "${azurerm_subnet.VMvnet_subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.public_ip.id}"
  }
}

#Windows VM
resource "azurerm_virtual_machine" "vm" {
  name                             = "${var.vmname}"
  network_interface_ids            = ["${azurerm_network_interface.nic.id}"]
  location                         = "${azurerm_resource_group.AzureVMRG.location}"
  vm_size                          = "${var.vmsize}"
  resource_group_name              = "${azurerm_resource_group.AzureVMRG.name}"
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "${var.vmname}-OSdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "${var.publisher}"
    offer     = "${var.offer}"
    sku       = "${var.sku}"
    version   = "${var.osversion}"
  }

  os_profile {
    computer_name  = "${var.computerName}"
    admin_username = "localadmin"
    admin_password = "${var.adminpassword}" 
    }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}

#VM Extension
resource "azurerm_virtual_machine_extension" "antimalware" {
name                 = "IaaSAntimalware"
location             = "${azurerm_resource_group.AzureVMRG.location}"
resource_group_name  = "${azurerm_resource_group.AzureVMRG.name}"
virtual_machine_name = "${azurerm_virtual_machine.vm.name}"
publisher            = "Microsoft.Azure.Security"
type                 = "IaaSAntimalware"
type_handler_version = "1.1"
auto_upgrade_minor_version = "true"

settings = <<SETTINGS
    {
        "AntimalwareEnabled": true,
        "RealtimeProtectionEnabled": "true",
        "ScheduledScanSettings": {
            "isEnabled": "true",
            "day": "1",
            "time": "120",
            "scanType": "Quick"
            },
        "Exclusions": {
            "Extensions": "",
            "Paths": "",
            "Processes": ""
            }
    }
SETTINGS
}