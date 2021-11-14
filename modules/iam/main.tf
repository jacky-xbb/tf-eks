# IAM role allowing Kubernetes actions to access other AWS services

resource "aws_iam_role" "role" {
  name = var.iam_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "${var.service}.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "role_policy" {
  count = length(var.policy_arns)
  policy_arn = var.policy_arns[count.index]
  role = aws_iam_role.role.name
}
