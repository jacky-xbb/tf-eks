
# IAM configuration

module "iam" {
  source = "../../modules/iam"

  service = var.service
  iam_name = var.iam_name
  policy_arns = var.policy_arns
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-vpc"] # insert values here
  }
}

locals {
  arn_lst = split("/", data.aws_vpc.selected.arn)
}

data "aws_subnet_ids" "selected" {
  vpc_id = element(local.arn_lst, length(local.arn_lst)-1)
}

## Nodegroup

resource "aws_eks_node_group" "tf_node_grp" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = module.iam.role_arn
  subnet_ids      = data.aws_subnet_ids.selected.ids
  instance_types  = var.instance_types
  disk_size = var.disk_size

  scaling_config {
    desired_size = var.scaling_config["desired_size"]
    max_size     = var.scaling_config["max_size"]
    min_size     = var.scaling_config["min_size"]
  }

  depends_on = [
    module.iam.role_policy
  ]
}
