/*
*Author - Kasun Rajapakse
*Subject -  Enable Backup on a VM
*Language - HCL 
! Last Modify Date - Sep 7 2019
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

#provider

provider "azurerm" {

}

#Create Resource Group
resource "azurerm_resource_group" "recovery-vault-rg" {
  name     = "${var.vault_rg_name}"
  location = "${var.location}"
}


#Azure Recovery Service Vault
resource "azurerm_recovery_services_vault" "vm-backup-vault" {
  name                = "${var.vault_name}"
  location            = "${azurerm_resource_group.recovery-vault-rg.location}"
  sku                 = "${var.sku}"
  resource_group_name = "${azurerm_resource_group.recovery-vault-rg.name}"

}
#Create Backup Policy 

resource "azurerm_recovery_services_protection_policy_vm" "daily-policy" {
  name                = "${var.vm_backup_policy_name}"
  resource_group_name = "${azurerm_resource_group.recovery-vault-rg.name}"
  recovery_vault_name = "${azurerm_recovery_services_vault.vm-backup-vault.name}"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }
  retention_daily {
    count = 10
  }

  retention_weekly {
    count    = 42
    weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
  }


}

resource "azurerm_recovery_services_protected_vm" "vm1" {
  resource_group_name = "${azurerm_resource_group.recovery-vault-rg.name}"
  recovery_vault_name = "${azurerm_recovery_services_vault.vm-backup-vault.name}"
  source_vm_id        = "${azurerm_virtual_machine.vm.id}"
  backup_policy_id    = "${azurerm_recovery_services_protection_policy_vm.daily-policy.id}"

}

#Create vNet
resource "azurerm_virtual_network" "VMvnet" {
  resource_group_name = "${azurerm_resource_group.recovery-vault-rg.name}"
  location            = "${azurerm_resource_group.recovery-vault-rg.location}"
  address_space       = ["${var.vnet_cidr}"]
  name                = "${var.network_name}"
  tags = {
    Deployed = "Terrraform"
  }
}

#Create Subnet
resource "azurerm_subnet" "VMvnet_subnet" {
  name                 = "${var.subnet_name}"
  address_prefix       = "${var.subnet_cidr}"
  resource_group_name  = "${azurerm_resource_group.recovery-vault-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.VMvnet.name}"
}

#Create Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.prefix}-TFPIP"
  location            = "${azurerm_resource_group.recovery-vault-rg.location}"
  resource_group_name = "${azurerm_resource_group.recovery-vault-rg.name}"
  allocation_method   = "Dynamic"
  tags = {
    Deployed = "Terrraform"
  }

}

#Create NSG
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-NSG"
  resource_group_name = "${azurerm_resource_group.recovery-vault-rg.name}"
  location            = "${azurerm_resource_group.recovery-vault-rg.location}"
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

#Create NIC
resource "azurerm_network_interface" "nic" {
  name                      = "${var.prefix}-nic"
  location                  = "${azurerm_resource_group.recovery-vault-rg.location}"
  resource_group_name       = "${azurerm_resource_group.recovery-vault-rg.name}"
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

#Create VM
resource "azurerm_virtual_machine" "vm" {
  name                             = "${var.vmname}"
  network_interface_ids            = ["${azurerm_network_interface.nic.id}"]
  location                         = "${azurerm_resource_group.recovery-vault-rg.location}"
  vm_size                          = "${var.vmsize}"
  resource_group_name              = "${azurerm_resource_group.recovery-vault-rg.name}"
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
    sku       = "${var.vm-sku}"
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

resource "azurerm_managed_disk" "datadisk" {
  name                 = "${var.vmname}-disk1"
  location             = "${azurerm_resource_group.recovery-vault-rg.location}"
  resource_group_name  = "${azurerm_resource_group.recovery-vault-rg.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "datdiskattach" {
  managed_disk_id    = "${azurerm_managed_disk.datadisk.id}"
  virtual_machine_id = "${azurerm_virtual_machine.vm.id}"
  lun                = "10"
  caching            = "ReadWrite"
}

