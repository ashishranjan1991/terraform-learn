
resource "aws_iam_user" "user" {
  name         = var.iam_user_name
  path         = "/"
  force_destroy = true
}

# Attach an AWS managed policy (S3 read-only) to the user
resource "aws_iam_user_policy_attachment" "s3_readonly" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Small custom inline policy (example: allow EC2 describe actions)
data "aws_iam_policy_document" "custom" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "custom_policy" {
  name   = "${var.iam_user_name}-ec2-describe"
  user   = aws_iam_user.user.name
  policy = data.aws_iam_policy_document.custom.json
}

# Create access key for programmatic access
resource "aws_iam_access_key" "user_key" {
  user = aws_iam_user.user.name

}

output "iam_user_name" {
  value = aws_iam_user.user.name
}

output "access_key_id" {
  value = aws_iam_access_key.user_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.user_key.secret
  sensitive = true
    
}
