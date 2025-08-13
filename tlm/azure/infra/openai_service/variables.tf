variable "create" {
    type = bool
    description = "Whether to create the OpenAI service"
}

variable "openai_endpoint_url" {
    type = string
    description = "The URL of the OpenAI service (only set if create is false)"
    default = null
}

variable "openai_service_name" {
    type = string
    description = "The name of the OpenAI service"
}

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

variable "cognitive_deployments" {
    type = map(object({
        name = string
        model = string
        version = string
        format = string
        scale = string
        capacity = number
    }))
    description = "The cognitive deployments to create"
}
