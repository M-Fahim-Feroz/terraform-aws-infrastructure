output "ec2_role_name" {
  description = "The name of the IAM role attached to EC2"
  value       = aws_iam_role.ec2_role.name
}

output "ec2_instance_profile_name" {
  description = "The name of the IAM instance profile"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "ec2_role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.ec2_role.arn
}
