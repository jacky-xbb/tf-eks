variable "namespace" {
  type = string
}

variable "cluster_name" {
  type = string
}

data "aws_availability_zones" "available" {}

variable "cidr_block" {
  type = string
}
