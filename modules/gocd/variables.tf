variable "vpc_id" {}
variable "vpc_az" {}
variable "vpc_cidr_block" {}
variable "vpc_subnet_id" {}

variable "ami_id" {
  default = "ami-0ea3405d2d2522162"
}


variable "tags" {}

variable "module_tags" {
  default = {
    Terraform = true
  }
}

variable "instance_type" {
  default = "t3.medium"
}

variable "ssh_access" {
  default = false
}

variable "workstation-external-cidr" {}
