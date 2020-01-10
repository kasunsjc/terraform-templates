#variables 

variable "resourceGroup_name"{
    type = string
    default = "RG-SAP-Dev"
}

variable "location"{
    type = string
    default = "westeurope"
}

variable "vnet_name"{
    type = string
    default = "sap-dev-vnet"
}

variable "vnet_address_space"{
    type = string
    default = "10.10.0.0/16"
}

variable "mgt_subnet"{
    type = string
    default = "mgt-subnet"
}

variable "app_subnet"{
    type = string
    default = "app-subnet"
}

variable "db_subnet"{
    type = string
    default = "db-subnet"
}
variable "front_subnet"{
    type = string
    default = "front-subnet"
}

variable "mgt_subnet_prefix"{
    type = string
    default = "10.10.10.0/24"
}

variable "app_subnet_prefix"{
    type = string
    default = "10.10.15.0/24"
}

variable "db_subnet_prefix"{
    type = string
    default = "10.10.16.0/24"
}
variable "front_subnet_prefix"{
    type = string
    default = "10.10.14.0/24"
}

variable "mgt_nsg"{
    type = string
    default = "sap-mgt-nsg"
}
variable "front_nsg"{
    type = string
    default = "sap-front-nsg"
}
variable "app_nsg"{
    type = string
    default = "sap-app-nsg"
}
variable "db_nsg"{
    type = string
    default = "sap-db-nsg"
}
variable "sap_front_vm"{
    type = string 
    default = "CORP-AZ-FRONT"
}
variable "vm_size"{
    type = string
    default = "Standard_B8ms"
}
variable "admin_password"{

}
variable "admin_username"{
    type = string
    default = "sapadmin"
}