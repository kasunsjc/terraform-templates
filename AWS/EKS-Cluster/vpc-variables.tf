
variable "availability_zones" {
  description = "Availability zones for vpc subnets"
  type = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "private_subnets" {
  description = "Private Subnet CIDRs"
  type = list(string)
  default = ["10.10.100.0/24", "10.10.101.0/24"]
}

variable "public_subnets" {
  description = "Public Subnets for the Apps"
  type = list(string)
  default = ["10.10.1.0/24", "10.10.2.0/24"]
}