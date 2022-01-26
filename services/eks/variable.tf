variable "region" {
  default = "eu-west-1"
  type    = string
}

variable "cluster_name" {
  default = "tf-eks-cluster"
  type    = string
}

variable "namespace" {
  default = "tf-eks"
  type    = string
}

variable "base_cidr_block" {
  default = "10.0.0.0/16"
  type    = string
}

## IAM

variable "iam_name" {
  # default = "tf_eks_iam_role_01"
  default = "eksctl-managed-eks"
  type    = string
}

variable "service" {
  default = "eks"
  type    = string
}

variable "policy_arns" {
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
  type = list(any)
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
  default = [
    {
      description = "all"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}