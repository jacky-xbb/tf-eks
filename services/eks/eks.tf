# EKS Cluster Resources
# IAM Role to allow EKS service to manage other AWS services
# EC2 Security Group to allow networking traffic with EKS cluster
# EKS Cluster

# resource "aws_iam_role" "tf-eks-role" {
#   name = "tf_eks_iam_role"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_role_policy_attachment" "tf-eks-role-AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.tf-eks-role.name
# }

# resource "aws_iam_role_policy_attachment" "tf-eks-role-AmazonEKSServicePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
#   role       = aws_iam_role.tf-eks-role.name
# }


# OIDC config
# data "tls_certificate" "cert" {
#   url = aws_eks_cluster.tf-eks-cluster.identity[0].oidc[0].issuer
# }

# resource "aws_iam_openid_connect_provider" "cluster" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.cert.certificates[0].sha1_fingerprint]
#   url             = aws_eks_cluster.tf-eks-cluster.identity[0].oidc[0].issuer
# }

#####################

# IAM configuration

module "iam" {
  source = "../../modules/iam"

  service = var.service
  iam_name = var.iam_name
  policy_arns = var.policy_arns
}

# NETWORK configuration

module "networking" {
  source = "../../modules/networking"

  namespace = var.namespace
  cluster_name = var.cluster_name
}

# Security Group configuration

module "security_group" {
  source = "../../modules/security_group"

  namespace = var.namespace
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  egress_with_cidr_blocks = var.egress_with_cidr_blocks
  vpc_id = module.networking.vpc_id
}

resource "aws_security_group_rule" "cluster_ingress_workstation_https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = module.security_group.sg_id
  to_port           = 443
  type              = "ingress"
}

## EKS Cluster

resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = module.iam.role_arn

  vpc_config {
    security_group_ids = [module.security_group.sg_id]
    subnet_ids         = module.networking.subnet_ids
  }

  depends_on = [
    # aws_iam_role_policy_attachment.tf-eks-role-AmazonEKSClusterPolicy,
    # aws_iam_role_policy_attachment.tf-eks-role-AmazonEKSServicePolicy,
    module.iam.role_policy
  ]
}

## OIDC config

data "tls_certificate" "cert" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cert.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}


