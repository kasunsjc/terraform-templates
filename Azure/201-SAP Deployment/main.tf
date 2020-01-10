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

  subnet {
    name           = var.mgt_subnet
    address_prefix = "${var.mgt_subnet_prefix}"
    security_group = azurerm_network_security_group.nsg-mgt.id
  }

  subnet {
    name           = var.app_subnet
    address_prefix = "${var.app_subnet_prefix}"
    security_group = azurerm_network_security_group.nsg-app.id
  }

  subnet {
    name           = var.db_subnet
    address_prefix = "${var.db_subnet_prefix}"
    security_group = azurerm_network_security_group.nsg-db.id
  }
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

  tags = {
    env = "dev"
    App = "SAP"
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
}

#Create VMs

resource "azurerm_network_interface" "vm-nic"{
  name = var.sap_front_vm-nic
  location = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name = azurerm_resource_group.sap-deploy-rg.name
}

resource "azurerm_virtual_machine" "front-app" {
  name                = var.sap_front_vm
  location            = azurerm_resource_group.sap-deploy-rg.location
  resource_group_name = azurerm_resource_group.sap-deploy-rg.name
  vm_size = var.vm_size
  network_interface_ids = 
  storage_os_disk {
    name              = var.sap_front_vm-OSdisk
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
