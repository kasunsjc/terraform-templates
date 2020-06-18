provider "aws" {
  region = var.region
}

module "vpc_networking" {
  source = "./vpc_networking"
  region = var.region
  private_subnet1_cidr = var.private_subnet1_cidr
  private_subnet2_cidr = var.private_subnet2_cidr
  private_subnet3_cidr = var.private_subnet3_cidr
  public_subnet1_cidr = var.public_subnet1_cidr
  public_subnet2_cidr = var.public_subnet2_cidr
  public_subnet3_cidr = var.public_subnet3_cidr
  vpc_cidr = var.vpc_cidr
}

module "compute" {
  source = "./compute"
  region = var.region
  public_subnet1_id = module.vpc_networking.public_subnet1_id
  instance_name = var.instance_name
}