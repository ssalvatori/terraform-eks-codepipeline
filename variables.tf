variable "region" {}

# variable "vpc_id" {}

variable "environment_name" {}

variable "cluster_name" {}

# GitHub Configurations
variable "github_token" {}
variable "github_repository_name" {}
variable "github_repository_url" {}
variable "github_repository_owner" {}
variable "github_repository_branch" {}

# Tags
variable "author" {}

# Cluster size
variable "node_group_desired" {}
variable "node_group_max" {}
variable "node_group_min" {}


variable "k8s_dashboard_csrf" {}
