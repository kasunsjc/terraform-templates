#globle Variables
location = "Southeast Asia"
rg_name = "VM-KeyVault"

#Key Vault Variables
key_vault_rg = "Docker"
key_vault_name = "EncriptVault"
secret_name = "admin-windows-linux"

#Network Variables
network_name = "simplevm-vnet"
vnet_cidr    = "10.100.0.0/16"
subnet_name  = "server-subnet"
subnet_cidr = "10.100.10.0/24"

#VM Variables
prefix = "linux-vm"
publisher = "Canonical"
offer = "UbuntuServer"
sku = "16.04-LTS"
osversion = "latest"
vmname = "linuxvm"
vmsize = "Standard_DS1_v2"
computerName = "SimpleVM"
