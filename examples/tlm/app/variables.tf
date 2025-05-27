variable "environment" {
    type = string
    description = "Environment name (e.g. staging, production)"
}

variable "location" {
    type = string
    description = "Location where the Azure resources are deployed"
}

variable "resource_group_name" {
    type = string
    description = "Name of the resource group where Azure resources live"
}

variable "default_completion_model" {
    type = string
    description = "Default model to use for completions"
}

variable "default_embedding_model" {
    type = string
    description = "Default model to use for embeddings"
}

variable "app_version" {
    type = string
    description = "Version of the TLM to deploy"
}
