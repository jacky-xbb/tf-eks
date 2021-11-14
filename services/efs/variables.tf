data "aws_availability_zones" "available" {}

variable "region" {
  default = "ap-southeast-1"
  type = string
}

variable "namespace" {
  default = "tf-efs"
  type = string
}

variable "eks_namespace" {
  default = "tf-eks"
  type = string
}

## Security Group

variable "ingress_with_cidr_blocks" {
  description = "ingress of efs with cidr blocks"
  type        = list(any)
  default     = []
}

variable "egress_with_cidr_blocks" {
  description = "egress of efs with cidr blocks"
  type        = list(any)
  default     = []
}

