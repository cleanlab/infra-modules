variable "release_name" {
    description = "Name of the TLM app to deploy"
    type = string
    default = "tlm"
}

variable "aws_region" {
    description = "The AWS region for Bedrock endpoints"
    type        = string
}

variable "namespace" {
    description = "Namespace in which to deploy the TLM app"
    type = string
    default = "tlm"
}

variable "app_version" {
    type = string
    description = "The version of the TLM to deploy"
    default = "0.1.52"
}

variable "app_image_tag" {
    type = string
    description = "The image tag of the TLM chat backend service to deploy. If null, app_version is used as a fallback."
    default = null
}

variable "registry_server" {
    type = string
    description = "The registry server to pull images from"
    default = "043170249292.dkr.ecr.us-west-2.amazonaws.com"
}

variable "registry_name" {
    type = string
    description = "The name of the container registry to pull images from for the TLM backend service"
    default = "tlm/chat-backend"
}

variable "default_completion_model" {
    type = string
    description = "The default completion model to use"
    default = "gpt-4.1-mini"
}

variable "lowest_latency_model" {
    type = string
    description = "The lowest latency model available"
    default = "gpt-4.1-nano"
}

variable "enable_external_access" {
    type = bool
    description = "Whether to enable external access to the chat backend service"
    default = false
}

variable "bedrock_endpoint" {
  description = "The Bedrock service endpoint URL"
  type        = string
  default     = "https://bedrock-runtime.us-west-2.amazonaws.com"
}

variable "model_config_file_path" {
  description = "Path to the JSON model providers configuration file"
  type        = string
  default     = null
}

variable "cluster_oidc_provider_arn" {
  description = "The OIDC provider ARN from the EKS cluster"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL from the EKS cluster"
  type        = string
}

variable "service_account_name" {
  description = "Name of the Kubernetes service account"
  type        = string
  default     = "tlm-chat-backend"
}

variable "openai_api_key_secret_name" {
  description = "Name of the AWS Secrets Manager secret containing the OpenAI API key"
  type        = string
}
