provider "azurerm" {
  version = "=1.28.0"
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
  allocation_method   = "Dynamic"
  tags = {
    Deployed = "Terrraform"
  }

}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-NSG"
  resource_group_name = "${azurerm_resource_group.AzureVMRG.name}"
  location            = "${azurerm_resource_group.AzureVMRG.location}"
  tags = {
    Deployed = "Terrraform"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

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

resource "azurerm_managed_disk" "datadisk" {
  name                 = "${var.vmname}-disk1"
  location             = "${azurerm_resource_group.AzureVMRG.location}"
  resource_group_name  = "${azurerm_resource_group.AzureVMRG.name}"
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

