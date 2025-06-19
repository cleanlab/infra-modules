variable "environment" {
    type = string
    description = "The environment to deploy the TLM OpenAI serviceto"
}

variable "location" {
    type = string
    description = "The location to deploy the TLM OpenAI service to"
}

variable "resource_group_name" {
    type = string
    description = "The name of the resource group to deploy the TLM OpenAI service to"
}

variable "tags" {
    type = map(string)
    description = "The tags to apply to the resources"
}

variable "app_version" {
    type = string
    description = "The version of the TLM to deploy"
}

variable "app_image_tag" {
    type = string
    description = "The image tag of the TLM chat backend service to deploy. If null, app_version is used as a fallback."
    default = null
}

variable "cluster_oidc_issuer_url" {
    type = string
    description = "The OIDC issuer URL of the cluster"
}

variable "openai_service_name" {
    type = string
    description = "The name of the OpenAI service"
}

variable "openai_service_resource_group_name" {
    type = string
    description = "The name of the resource group containing the OpenAI service"
}

variable "registry_server" {
    type = string
    description = "The registry server to pull images from"
    default = "tlmcleanlab.azurecr.io"
}

variable "registry_name" {
    type = string
    description = "The name of the container registry to pull images from for the TLM backend service"
    default = "tlm/chat-backend"
}

variable "image_pull_username" {
    type = string
    description = "The username to pull images from the registry"
}

variable "image_pull_password" {
    type = string
    description = "The password to pull images from the registry"
    sensitive = true
}

variable "default_completion_model" {
    type = string
    description = "The default completion model to use"
}

variable "default_embedding_model" {
    type = string
    description = "The default embedding model to use"
}

variable "enable_external_access" {
    type = bool
    description = "Whether to enable external access to the chat backend service"
    default = false
}
