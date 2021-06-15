output "vpc_id" {
  description = "VPC ID of the application"
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR Block"
  value = module.vpc.vpc_cidr_block
}

output "availability_zones" {
  description = "Availability Zones used for VPC deployment"
  value = module.vpc.azs
}

output "private_subnets" {
  description = "Private Subnet"
  value = module.vpc.private_subnets
}

output "public_subnets" {
  description = "VPC Public Subnets"
  value = module.vpc.public_subnets
}