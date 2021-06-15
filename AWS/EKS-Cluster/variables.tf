//Change the region accordingly, using ap-southeast-1 since i am deploying in Singapore Region
variable "region" {
  description = "name of the region"
  type        = string
  default     = "us-east-1"
}

variable "business_division" {
  default = "hr"
  description = "Organization Unit"
}

variable "environment" {
  default = "dev"
  description = "Application environment"
}

variable "iam_role_arn" {
  description = "arn of node group role"
  type        = string
  default     = ""
}

variable "subnets" {
  description = "subnets for the eks cluster"
  type        = list(string)
  default     = [
    "subnet-00000000000000000",
    "subnet-11111111111111111"
  ]
}

variable "cluster_security_group_id" {
  description = "security group for eks cluster"
  type        = string
  default     = ""
}

variable "worker_security_group_id" {
  description = "security group for eks node group"
  type        = string
  default     = ""
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)
#Master account number
  default = [
    "11111111111111"
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::1111111111:role/KubectlRole"
      username = "build"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::222222222222:user/adminuser"
      username = "build"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::222222222222:user/serviceuser"
      username = "build"
      groups   = ["system:masters"]
    }
  ]
}

variable "ssh_key_name" {
  description = "ssh key pair name for the workernode access."
  type        = string
  default     = ""
}

//Use your own tags
variable "tags" {
  description = "A mapping of tags"
  type        = map(string)
  default     = {
    Owner       = ""
    Environment = ""
  }
}