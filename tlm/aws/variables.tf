variable "aws_region" {
  description = "The AWS region to deploy resources to"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "The environment to deploy to"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy the cluster to"
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets to deploy the cluster to"
  type        = list(string)
}

variable "app_image_tag" {
  description = "Name of the chat backend container image tag to run"
  type = string
  default = "0.1.2"
}

variable "openai_api_key_secret_name" {
  description = "Name of the secret in AWS secrets manager to read OpenAI API key from"
  type = string
}

variable "enable_external_access" {
  description = "Whether to enable a public IP for the TLM app or not"
  type = bool
  default = false
}
