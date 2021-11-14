output "subnet_ids" {
  description = "the ids of subnet"
  value       = aws_subnet.tf_eks_subnet[*].id
}

output "vpc_id" {
  description = "the vpc id"
  value = aws_vpc.tf_eks_vpc.id
}