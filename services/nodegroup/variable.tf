variable "region" {
  default = "ap-southeast-1"
  type = string
}

variable "namespace" {
  default = "tf-eks"
  type = string
}

variable "cluster_name" {
  default = "tf-eks-cluster"
  type    = string
}

variable "node_group_name" {
  default = "tf-emqx-group"
  type = string
}

variable "instance_types" {
  default = ["t2.medium"]
  type = list
}

variable "disk_size" {
  default = 20
  type = number
}

variable "scaling_config" {
  default = {
    "desired_size" = 3
    "max_size"     = 5
    "min_size"     = 1
  }
  type = map
}

## IAM
variable "iam_name" {
  default = "tf-ng-iam-role"
}

variable "service" {
  default = "ec2"
  type = string
}

variable "policy_arns" {
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  type = list
}
