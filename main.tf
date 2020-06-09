provider "aws" {
  region = var.region
}

module "git-hash" {
  source  = "matti/resource/shell"
  command = "git rev-parse --short HEAD"
}

resource "aws_ecr_repository" "this" {
  name                 = replace(lower(var.cluster_name), " ", "-")
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name      = var.cluster_name
    Terraform = true
    Author    = var.author
    Git_Hash  = module.git-hash.stdout
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.39.0"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-central-1c", "eu-central-1a", "eu-central-1b"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]


  # One NAT per AZ
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  tags = {
    Terraform = "true"
    Author    = var.author
    Git_Hash  = module.git-hash.stdout
  }

  vpc_tags = {
    Name = var.cluster_name
  }

  # VPC Tagging
  # https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html

  private_subnet_tags = {
    Author                                      = var.author
    Git_Hash                                    = module.git-hash.stdout
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }

  public_subnet_tags = {
    Author                                      = var.author
    Git_Hash                                    = module.git-hash.stdout
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

}

module "eks" {
  source = "./modules/eks"

  vpc_id          = module.vpc.vpc_id
  cluster_name    = var.cluster_name
  environment     = var.environment_name
  private_subnets = module.vpc.private_subnets

  instance_types = ["t3.medium"]

  tags = {
    Author   = var.author
    Git_Hash = module.git-hash.stdout
  }

  node_group_desired = var.node_group_desired
  node_group_max     = var.node_group_max
  node_group_min     = var.node_group_min

}

module "k8s" {
  source = "./modules/k8s"

  k8s_host           = module.eks.endpoint
  k8s_ca_certificate = module.eks.ca_certificate
  k8s_token          = module.eks.token
}

data "aws_caller_identity" "current" {}

# module "build_pipeline" {
#   source = "./modules/codepipeline"

#   account_id  = data.aws_caller_identity.current.account_id
#   region      = var.region
#   environment = var.environment_name

#   project_name = var.cluster_name

#   # github_repository      = var.github_repository_url
#   github_token             = var.github_token
#   github_repository_owner  = var.github_repository_owner
#   github_repository_branch = var.github_repository_branch
#   github_repository_name   = var.github_repository_name

#   tags = {
#     Author   = var.author
#     Git_Hash = module.git-hash.stdout
#   }

# }
