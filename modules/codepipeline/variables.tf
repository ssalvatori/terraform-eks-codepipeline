variable "region" {}

variable "project_name" {}

variable "account_id" {}

variable "environment" {}

variable "github_token" {}

variable "github_repository_owner" {}

variable "github_repository_branch" {}

variable "github_repository_name" {}

variable "module_tags" {
  default = {
    Terraform = true
  }
}

variable "tags" {}
