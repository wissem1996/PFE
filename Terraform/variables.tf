variable "region" {
  type    = string
  default = "eu-west-3"

}
variable "profile" {
  type    = string
  default = "techuser"

}

###### EKS ######

variable "cluster_name" {
  type    = string
  default = "clusteralpha"
}

variable "cluster_version" {
  type    = string
  default = "1.27"

}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = true
}
variable "cluster_endpoint_private_access" {
  type = bool
  default = false
}
variable "instance_type" {
  type    = string
  default = "t3.small"
}
variable "instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "capacity_type" {
  type    = string
  default = "SPOT"

}

###### VPC ######

variable "name" {
  type    = string
  default = "my-vpc"

}
variable "cidr" {
  type    = string
  default = "10.0.0.0/16"

}
variable "azs" {
  type    = list(string)
  default = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]

}
variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]

}
variable "public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24"]
}
variable "min_size" {
  type = number
  default = 2
}
variable "max_size" { 
  default = 10
  type = number
}
variable "desired_size" {
  type = number
  default = 2
  
}
######## Karpenter controller ######
# variable "identifiers" {
   
#     default = [aws_iam_openid_connect_provider.eks.arn]
  
# }
# variable "assume_role_policy" {
#   default = module.karpenter-controller-role.data.aws_iam_policy_document.karpenter_controller_assume_role_policy.json
  
# }
# variable "policy" {

# }
# variable "role" {
#   default = module.karpenter-controller-role.karpenter_controller.name
# }
# variable "policy_arn" {
#   default = module.karpenter-controller-role.karpenter_controller.arn
# }
variable "namespace" {
    type = string
    default = "monitoring"
}
variable "kube-version" {
    default = "36.2.0"

}