/*
*Author - Kasun Rajapakse
*Subject - Create SAP Dev Enviornment
*Language - HCL 
! Last Modify Date - Jan 10 2020
*/

#Create Resource Group 

resource "azurerm_resource_group" "sap-deploy-rg" {
  name     = var.resourceGroup_name
  location = var.location
  tags = {
    env = "dev"
    App = "SAP"
  }
}

#Create VNET

resource "azurerm_virtual_network" "sap-vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.sap-deploy-rg.name
  address_space       = ["${var.vnet_address_space}"]
  tags = {
    env = "dev"
    App = "SAP"
  }
}

resource "azurerm_subnet" "mgt-subnet" {
  name                      = var.mgt_subnet
  resource_group_name       = azurerm_resource_group.sap-deploy-rg.name
  virtual_network_name      = azurerm_virtual_network.sap-vnet.name
  address_prefix            = var.mgt_subnet_prefix
  network_security_group_id = azurerm_network_security_group.nsg-mgt.id


}

resource "azurerm_subnet" "front-subnet" {
  name                      = var.front_subnet
  resource_group_name       = azurerm_resource_group.sap-deploy-rg.name
  virtual_network_name      = azurerm_virtual_network.sap-vnet.name
  address_prefix            = var.front_subnet_prefix
  network_security_group_id = azurerm_network_security_group.nsg-front.id

}

resource "azurerm_subnet" "app-subnet" {
  name                      = var.app_subnet
  resource_group_name       = azurerm_resource_group.sap-deploy-rg.name
  virtual_network_name      = azurerm_virtual_network.sap-vnet.name
  address_prefix            = var.app_subnet_prefix
  network_security_group_id = azurerm_network_security_group.nsg-app.id

}

resource "azurerm_subnet" "db-subnet" {
  name                      = var.db_subnet
  resource_group_name       = azurerm_resource_group.sap-deploy-rg.name
  virtual_network_name      = azurerm_virtual_network.sap-vnet.name
  address_prefix            = var.db_subnet_prefix
  network_security_group_id = azurerm_network_security_group.nsg-db.id


}

#Create NSGs
/*
TODO - ADD NSG Rules 
*/
resource "azurerm_network_security_group" "nsg-mgt" {
  name                = var.mgt_nsg
  location            = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name = azurerm_resource_group.sap-deploy-rg.name

  security_rule {
    name                       = "INB-HTTP-Allow"
    description                = "Allow HTTP traffic from Public"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "INB-HTTPS-Allow"
    description                = "Allow HTTPS traffic from Public"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "433"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "INB-RDP-Allow-SL"
    description                = "Allow RDP traffic from Organizations Network"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3389"
    destination_port_range     = "*"
    source_address_prefixes    = ["14.140.59.42", "65.211.16.189"]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH-Allow"
    description                = "Allow SSH traffic from Public"
    priority                   = 1300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  tags = {
    env = "dev"
    App = "SAP"
  }

}

resource "azurerm_network_security_group" "nsg-front" {
  name                = var.front_nsg
  location            = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name = azurerm_resource_group.sap-deploy-rg.name

  security_rule {
    name                       = "INB-HTTP-Allow"
    description                = "Allow HTTP traffic from Public"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_network_security_group" "nsg-app" {
  name                = var.app_nsg
  location            = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name = azurerm_resource_group.sap-deploy-rg.name

  security_rule {
    name                       = "INB-HTTP-Allow"
    description                = "Allow HTTP traffic from Public"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "nsg-db" {
  name                = var.db_nsg
  location            = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name = azurerm_resource_group.sap-deploy-rg.name

  security_rule {
    name                       = "INB-HTTP-Allow"
    description                = "Allow HTTP traffic from Public"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH-Allow"
    description                = "Allow SSH traffic from Public"
    priority                   = 1300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}


#---------------------Create VMs---------------------------#

#---------------------Front Server--------------------------#

resource "azurerm_network_interface" "front-vm-nic" {
  name                = "${var.sap_front_vm}-nic"
  location            = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name = azurerm_resource_group.sap-deploy-rg.name
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_version    = "IPv4"
    subnet_id                     = azurerm_subnet.front-subnet.id
    primary                       = true
    private_ip_address_allocation = "static"
    private_ip_address            = "10.10.14.7"

  }
}

resource "azurerm_virtual_machine" "front-vm" {
  name                  = var.sap_front_vm
  location              = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name   = azurerm_resource_group.sap-deploy-rg.name
  vm_size               = var.vm_size
  network_interface_ids = ["${azurerm_network_interface.front-vm-nic.id}"]
  storage_os_disk {
    name              = "${var.sap_front_vm}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.sap_front_vm
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}
#---------------------End of Front Server ----------------------#
#----------------------SAP-APP Server ------------------------------#

resource "azurerm_network_interface" "app-vm-nic" {
  name                = "${var.sap_app_vm}-nic"
  location            = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name = azurerm_resource_group.sap-deploy-rg.name
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_version    = "IPv4"
    subnet_id                     = azurerm_subnet.app-subnet.id
    primary                       = true
    private_ip_address_allocation = "static"
    private_ip_address            = "10.10.15.7"

  }
}


#Disks

resource "azurerm_managed_disk" "sap-app-data" {
  name                 = "sap-app-data01"
  create_option        = "Empty"
  location             = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name  = azurerm_resource_group.sap-deploy-rg.name
  storage_account_type = "Standard_LRS"
  disk_size_gb         = "250"
}

resource "azurerm_virtual_machine_data_disk_attachment" "sap-app-data-attach" {
  managed_disk_id    = azurerm_managed_disk.sap-app-data.id
  virtual_machine_id = azurerm_virtual_machine.app-vm.id
  lun                = "15"
  caching            = "ReadWrite"
}


resource "azurerm_virtual_machine" "app-vm" {
  name                  = var.sap_app_vm
  location              = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name   = azurerm_resource_group.sap-deploy-rg.name
  vm_size               = var.vm_size
  network_interface_ids = ["${azurerm_network_interface.app-vm-nic.id}"]
  storage_os_disk {
    name              = "${var.sap_app_vm}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.sap_front_vm
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}
#---------------------- End SAP-APP Server ------------------------------#
#----------------------Fiori UI Server ------------------------------#

resource "azurerm_network_interface" "fioriui-vm-nic" {
  name                = "${var.fiori_ui_vm}-nic"
  location            = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name = azurerm_resource_group.sap-deploy-rg.name
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_version    = "IPv4"
    subnet_id                     = azurerm_subnet.app-subnet.id
    primary                       = true
    private_ip_address_allocation = "static"
    private_ip_address            = "10.10.15.8"

  }
}

resource "azurerm_virtual_machine" "fioriui-vm" {
  name                  = var.fiori_ui_vm
  location              = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name   = azurerm_resource_group.sap-deploy-rg.name
  vm_size               = var.vm_size
  network_interface_ids = ["${azurerm_network_interface.fioriui-vm-nic.id}"]
  storage_os_disk {
    name              = "${var.fiori_ui_vm}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.fiori_ui_vm
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}
#----------------------End Fiori UI Server ------------------------------#
#----------------------Hana Server ------------------------------#


resource "azurerm_network_interface" "hana-vm-nic" {
  name                = "${var.sap_hana_vm}-nic"
  location            = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name = azurerm_resource_group.sap-deploy-rg.name
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_version    = "IPv4"
    subnet_id                     = azurerm_subnet.db-subnet.id
    primary                       = true
    private_ip_address_allocation = "static"
    private_ip_address            = "10.10.16.7"

  }
}

#Disks

resource "azurerm_managed_disk" "data-sap" {
  name                 = "sap-data01"
  create_option        = "Empty"
  location             = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name  = azurerm_resource_group.sap-deploy-rg.name
  storage_account_type = "Premium_LRS"
  disk_size_gb         = "512"
}

resource "azurerm_virtual_machine_data_disk_attachment" "sap-data-attach" {
  managed_disk_id    = azurerm_managed_disk.data-sap.id
  virtual_machine_id = azurerm_virtual_machine.hana-vm.id
  lun                = "10"
  caching            = "ReadWrite"
}

resource "azurerm_managed_disk" "sap-app" {
  name                 = "sap-app01"
  create_option        = "Empty"
  location             = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name  = azurerm_resource_group.sap-deploy-rg.name
  storage_account_type = "Premium_LRS"
  disk_size_gb         = "64"
}

resource "azurerm_virtual_machine_data_disk_attachment" "sap-app-attach" {
  managed_disk_id    = azurerm_managed_disk.sap-app.id
  virtual_machine_id = azurerm_virtual_machine.hana-vm.id
  lun                = "11"
  caching            = "ReadWrite"
}

resource "azurerm_managed_disk" "sap-log" {
  name                 = "sap-log01"
  create_option        = "Empty"
  location             = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name  = azurerm_resource_group.sap-deploy-rg.name
  storage_account_type = "Premium_LRS"
  disk_size_gb         = "128"
}

resource "azurerm_virtual_machine_data_disk_attachment" "sap-log-attach" {
  managed_disk_id    = azurerm_managed_disk.sap-log.id
  virtual_machine_id = azurerm_virtual_machine.hana-vm.id
  lun                = "12"
  caching            = "ReadWrite"
}


resource "azurerm_virtual_machine" "hana-vm" {
  name                  = var.sap_hana_vm
  location              = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name   = azurerm_resource_group.sap-deploy-rg.name
  vm_size               = var.hana_vm_size
  network_interface_ids = ["${azurerm_network_interface.hana-vm-nic.id}"]
  depends_on = [
    azurerm_managed_disk.data-sap,
    azurerm_managed_disk.sap-log,
    azurerm_managed_disk.sap-app
  ]
  storage_os_disk {
    name              = "${var.sap_hana_vm}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL-SAP-HANA"
    sku       = "7.3"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.sap_hana_vm
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = <<-EOF
      #!/bin/bash
      yum update -y
      yum upgrade -y
    
    EOF
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
#----------------------End Hana Server ------------------------------#

#----------------------Jumpbox Server ------------------------------#

resource "azurerm_public_ip" "jumpbox-pip" {
  name                = "${var.jumpbox_vm}-pip"
  location            = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name = azurerm_resource_group.sap-deploy-rg.name
  allocation_method = "Static"
  domain_name_label = "jumpbox-sap"

}

resource "azurerm_network_interface" "jumpbox-vm-nic" {
  name                = "${var.jumpbox_vm}-nic"
  location            = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name = azurerm_resource_group.sap-deploy-rg.name
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_version    = "IPv4"
    subnet_id                     = azurerm_subnet.mgt-subnet.id
    primary                       = true
    private_ip_address_allocation = "static"
    private_ip_address            = "10.10.10.7"
    public_ip_address_id = azurerm_public_ip.jumpbox-pip.id

  }
}

resource "azurerm_virtual_machine" "jumpbox-vm" {
  name                  = var.jumpbox_vm
  location              = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name   = azurerm_resource_group.sap-deploy-rg.name
  vm_size               = var.vm_size
  network_interface_ids = ["${azurerm_network_interface.jumpbox-vm-nic.id}"]
  storage_os_disk {
    name              = "${var.jumpbox_vm}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.jumpbox_vm
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}
