terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    # Cluster-Autoscaler = {
    #   most_recent = true
    # }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  # Self Managed Node Group(s)
  self_managed_node_group_defaults = {
    instance_type                          = var.instance_type
    update_launch_template_default_version = true
    iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = var.instance_types
  }

  eks_managed_node_groups = {

    green = {
      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size

      instance_types = var.instance_types
      capacity_type  = var.capacity_type
    }
  }
  # Extend node-to-node security group rules to fix the 504 gateway problem on ingress
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
   aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::231789677311:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS"
      username = "AWSServiceRoleForAmazonEKS"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::231789677311:user/techuser"
      username = "techuser"
      groups   = ["system:masters"]
    }
  ]
  enable_irsa = true
  manage_aws_auth_configmap = false
  create_aws_auth_configmap = false

  tags = {
    Environment = "dev"
    Terraform   = "true"
    //*****//
    "karpenter.sh/discovery" = "clusteralpha"
  }
}
//*****//
data "aws_iam_policy" "ssm_managed_instance" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
//*****//
resource "aws_iam_role_policy_attachment" "karpenter_ssm_policy" {
  role       = module.eks.eks_managed_node_groups["green"].iam_role_name
  policy_arn = data.aws_iam_policy.ssm_managed_instance.arn
}
//*****//
resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeInstanceProfile-clusteralpha"
  role = module.eks.eks_managed_node_groups["green"].iam_role_name
}
//*****//
module "iam_assumable_role_karpenter" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.7.0"
  create_role                   = true
  role_name                     = "karpenter-controller-clusteralpha"
  provider_url                  = module.eks.cluster_oidc_issuer_url
  oidc_fully_qualified_subjects = ["system:serviceaccount:karpenter:karpenter"]
}
//*****//
resource "aws_iam_role_policy" "karpenter_controller" {
  name = "karpenter-policy-${var.cluster_name}"
  role = module.iam_assumable_role_karpenter.iam_role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:RunInstances",
          "ec2:CreateTags",
          "iam:PassRole",
          "ec2:TerminateInstances",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeAvailabilityZones",
          "ssm:GetParameter"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
//*****//
resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true
  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "v0.6.0"
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_karpenter.iam_role_arn
  }
  set {
    name  = "controller.clusterName"
    value = var.cluster_name
  }
  set {
    name  = "controller.clusterEndpoint"
    value = module.eks.cluster_endpoint
  }
  set {
    name  = "aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name
  }
}
 resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "3.35.4"
  values           = [file("eks/values/argocd.yaml")]
}

resource "kubectl_manifest" "provisioners" {
  
  yaml_body = <<YAML
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: provisioner
spec:
  provider:
    apiVersion: extensions.karpenter.sh/v1alpha1
    kind: AWS
    securityGroupSelector:
      Name: "clusteralpha-node"
    subnetSelector:
      karpenter.sh/discovery: clusteralpha
  requirements:
  - key: node.kubernetes.io/instance-type
    operator: In
    values:
    - t3.medium
  - key: karpenter.sh/capacity-type
    operator: In
    values:
    - on-demand
  - key: kubernetes.io/arch
    operator: In
    values:
    - amd64
  ttlSecondsAfterEmpty: 30
  ttlSecondsUntilExpired: 172800
YAML
depends_on = [ helm_release.karpenter ]
}

# resource "aws_route53_zone" "eks" {
#   name = "espritpfe.com"
# }
# resource "aws_route53_record" "eks_endpoint" {
#   zone_id = aws_route53_zone.eks.zone_id
#   name    = "www"
#   type    = "A"
#   ttl     = "300"
#   records = [ module.eks.cluster_endpoint]
# }

