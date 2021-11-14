output "role_arn" {
  value       = aws_iam_role.role.arn
  description = "the arn of the role"
}

output "role_policy" {
  value       = aws_iam_role_policy_attachment.role_policy
  description = "the policy of the role"
}

