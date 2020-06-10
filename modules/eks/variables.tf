variable "cluster_name" {}

variable "vpc_id" {}

variable "private_subnets" {}

variable "tags" {}

variable "environment" {}

variable "module_tags" {
  default = {
    Terraform = true
  }
}

variable "node_group_desired" {
  default = 1
}
variable "node_group_max" {
  default = 1
}
variable "node_group_min" {
  default = 1
}

variable "instance_types" {
  default = ["t3.medium"]
}

variable "workstation-external-cidr" {}
