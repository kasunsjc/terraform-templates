rg-name                = "SimpleTFVM"
location               = "Southeast Asia"
network_name           = "simplevm-vnet"
vnet_cidr              = "10.100.0.0/16"
subnet_name            = "server-subnet"
subnet_cidr            = "10.100.10.0/24"
prefix                 = "win-vm"
publisher              = "MicrosoftWindowsServer"
offer                  = "WindowsServer"
sku                    = "2019-Datacenter"
osversion              = "latest"
vmname                 = "windowsvm"
vmsize                 = "Standard_DS1_v2"
adminpassword          = "Test@123"
computerName           = "SimpleVM"
logAnalytics_sku       = "Free"
logAnalytics_retension = "30"
