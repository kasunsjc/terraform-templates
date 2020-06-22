variable "region" {
  description = "Region for Resource Deployment"
}

variable "vnet_rg" {
  description = "Virtual Network RG Name"
}

variable "vnet_cidr" {
  description = "CIDR of the VNet"
}

variable "vnet_name" {
  description = "VNet Name"
}

variable "frontend_subnet_name" {
  description = "Frontend Subnet Name"
}

variable "frontend_subnet_cidr" {
  description = "CIDR for frontend Subnet"
}

variable "backend_subnet_name" {
  description = "Backend Subnet Name"
}

variable "backend_subnet_cidr" {
  description = "CIDR for backend Subnet"
}
