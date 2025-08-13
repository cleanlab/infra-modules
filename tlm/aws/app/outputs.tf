output "helm_release_status" {
  description = "Status of the Helm release"
  value = helm_release.this.status
}

output "service_account_name" {
  description = "Name of the created service account"
  value = kubernetes_service_account.chat_backend.metadata[0].name
}

output "service_account_namespace" {
  description = "Namespace of the service account"
  value = kubernetes_service_account.chat_backend.metadata[0].namespace
}

output "iam_role_arn" {
  description = "ARN of the IAM role for the service account"
  value = aws_iam_role.chat_backend_role.arn
}

output "iam_role_name" {
  description = "Name of the IAM role for the service account"
  value = aws_iam_role.chat_backend_role.name
}

output "openai_api_key_secret_arn" {
  description = "ARN of the OpenAI API key secret in AWS Secrets Manager"
  value = data.aws_secretsmanager_secret.openai_api_key.arn
}

output "openai_api_key_secret_name" {
  description = "Name of the OpenAI API key secret in AWS Secrets Manager"
  value = data.aws_secretsmanager_secret.openai_api_key.name
}
