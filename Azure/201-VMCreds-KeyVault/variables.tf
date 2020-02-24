#START Globle Variables
variable "location" {
  
}
variable "rg_name" {
  
}
#END Globle Variables

#START Key Vault Variables
variable "key_vault_rg" {
  
}
variable "key_vault_name" {
  
}
variable "secret_name" {
  
}
#END Key Vault Variables

#START Network Variables

variable "network_name" {
  type        = "string"
  default     = "simplevm-vnet"
  description = "VNet Name"

}

variable "vnet_cidr" {
  type        = "string"
  default     = "10.100.0.0/16"
  description = "Address Space for the VNet"

}

variable "subnet_name" {
  type        = "string"
  default     = "server-subnet"
  description = "VNet Subnet"

}

variable "subnet_cidr" {
  type        = "string"
  default     = "10.100.10.0/24"
  description = "Address Space for the Subnet"
}

variable "prefix" {
  type        = "string"
  default     = "vm"
  description = "Address Space for the Subnet"

}
#END Network Variables

#START VM Variables

variable "vmname" {
}

variable "publisher" {
}

variable "offer" {
}

variable "sku" {
}

variable "osversion" {
}

variable "vmsize" {
  default = "Standard_DS1_v2"
}


variable "computerName" {
  default = "SimpleVM"
}

#END VM Variables



