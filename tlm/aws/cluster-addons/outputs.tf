output "load_balancer_controller_role_arn" {
  description = "The ARN of the Load Balancer Controller IAM role"
  value       = aws_iam_role.load_balancer_controller.arn
}

output "load_balancer_controller_policy_arn" {
  description = "The ARN of the Load Balancer Controller IAM policy"
  value       = aws_iam_policy.load_balancer_controller.arn
}
