# Security Group
# EFS and Resources

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.eks_namespace}-vpc"] # insert values here
  }
}

locals {
  arn_lst = split("/", data.aws_vpc.selected.arn)
}

data "aws_subnet_ids" "selected" {
  vpc_id = element(local.arn_lst, length(local.arn_lst)-1)
}

module "security_group" {
  source = "../../modules/security_group"

  namespace = var.namespace
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  egress_with_cidr_blocks = var.egress_with_cidr_blocks
  vpc_id = data.aws_subnet_ids.selected.vpc_id
}

resource "aws_efs_file_system" "tf_efs_fs" {
  creation_token = "eks-efs-file-system"
  tags = {
    Name = "${var.namespace}-fs"
  }
}

resource "aws_efs_mount_target" "tf_efs_mnt_target" {
  count = length(data.aws_availability_zones.available.names)
  file_system_id = aws_efs_file_system.tf_efs_fs.id
  subnet_id      = tolist(data.aws_subnet_ids.selected.ids)[count.index]
  security_groups = [module.security_group.sg_id]
}

resource "aws_efs_access_point" "tf_efs_access_pt" {
  file_system_id = aws_efs_file_system.tf_efs_fs.id
}