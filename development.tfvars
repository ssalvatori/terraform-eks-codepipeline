#
# Development Environment
#

region                   = "eu-west-1"
vpc_azs                  = ["eu-west-1c", "eu-west-1a", "eu-west-1b"]
cluster_name             = "eks-test"
environment_name         = "dev"
github_repository_name   = "eks_sample_app"
github_repository_owner  = "ssalvatori"
github_repository_branch = "master"
github_repository_url    = "https://github.com/ssalvatori/eks_sample_app.git"
author                   = "stefano_salvatori"
node_group_desired       = 3
node_group_max           = 5
node_group_min           = 2
k8s_dashboard_csrf       = "test1234"
