locals {
  vpc_cidr = "10.10.0.0/16"
  owners = var.business_division
  environment = var.environment
  name = "${var.business_division}-${var.environment}"

  common_tags = {
    owners = local.owners
    env = local.environment
  }
}