variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.30.0.0/16"
}

variable "public_subnet1_cidr" {
  default = "10.30.10.0/24"
}

variable "public_subnet2_cidr" {
  default = "10.30.11.0/24"
}

variable "public_subnet3_cidr" {
  default = "10.30.12.0/24"
}

variable "private_subnet1_cidr" {
  default = "10.30.20.0/24"
}

variable "private_subnet2_cidr" {
  default = "10.30.21.0/24"
}

variable "private_subnet3_cidr" {
  default = "10.30.22.0/24"
}

variable "instance_name" {
  default = "example-instance"
}
