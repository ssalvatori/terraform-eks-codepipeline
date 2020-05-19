provider "aws" {
  region = var.region
}

module "git-hash" {
  source  = "matti/resource/shell"
  command = "git rev-parse --short HEAD"
}

module "module_eks" {
  source = "./modules/eks"

  vpc_id       = var.vpc_id
  cluster_name = var.cluster_name
  region       = var.region
  environment  = var.environment_name

  instance_types = ["t3.medium"]

  tags = {
    Author   = "stefano_salvatori"
    Git_Hash = module.git-hash.stdout
  }

}
