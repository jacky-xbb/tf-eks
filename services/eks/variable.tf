variable "region" {
  default = "ap-southeast-1"
  type = string
}

variable "cluster_name" {
  default = "tf-eks-cluster"
  type    = string
}

variable "namespace" {
  default = "tf-eks"
  type = string
}

variable "vpc_cidr_block" {
  default = "192.168.0.0/16"
  type = string
}

## IAM

variable "iam_name" {
  default = "tf_eks_iam_role"
}

variable "service" {
  default = "eks"
  type = string
}

variable "policy_arns" {
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
  type = list
}

## Security Group

variable "ingress_with_cidr_blocks" {
  description = "ingress of eks with cidr blocks"
  type        = list(any)
  default     = []
}

variable "egress_with_cidr_blocks" {
  description = "egress of eks with cidr blocks"
  type        = list(any)
  default     = []
}