variable "environment" {
  description = "The environment name"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_oidc_provider_arn" {
  description = "The ARN of the EKS cluster OIDC provider"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL for the EKS cluster"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
