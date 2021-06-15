module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.name}-vpc"
  cidr = local.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = local.common_tags

  public_subnet_tags = {
    Name = "${local.name}-public-subnets"
  }

  private_subnet_tags = {
    Name = "${local.name}-private-subnets"
  }

}