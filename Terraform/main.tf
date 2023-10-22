terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }
}
provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--profile", "techuser"]
      command     = "aws"
    }
  }
}

module "vpc" {
  source          = "./vpc"
  name            = var.name
  cidr            = var.cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}
module "ingress-controller" {
  source = "./ingress-controller/"

}
module "eks" {
  source                         = "./eks"
  vpc_id                         = module.vpc.vpc_id
  private_subnets                = module.vpc.private_subnets_ids
  public_subnets                 = module.vpc.public_subnets_ids
  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  instance_type                  = var.instance_type
  instance_types                 = var.instance_types
  capacity_type                  = var.capacity_type
  min_size                       = var.min_size
  max_size                       = var.max_size
  desired_size                   = var.desired_size


}