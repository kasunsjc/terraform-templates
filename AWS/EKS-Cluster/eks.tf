module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"
  cluster_name    = "${local.name}-eks"
  cluster_version = "1.20"
  subnets         = module.vpc.private_subnets

  tags = local.common_tags

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t3.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t3.medium"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    },
  ]

  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
//  map_roles                            = var.map_roles
//  map_users                            = var.map_users
//  map_accounts                         = var.map_accounts
}