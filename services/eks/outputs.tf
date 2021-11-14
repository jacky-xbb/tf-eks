# Outputs

locals {
  kubeconfig = <<KUBECONFIG

apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.cluster.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster_name}"
KUBECONFIG
}

output "kubeconfig" {
  value = local.kubeconfig
}

output "subnet_ids" {
  value       = module.networking.subnet_ids
}


resource "null_resource" "update" {
  depends_on = [
    aws_eks_cluster.cluster
  ]

  provisioner "local-exec" {
    command     = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
  }
}