variable "environment" {
    type = string
    description = "The environment to deploy the TLM to"
}

variable "entity" {
    type = string
    description = "The name of the entity deploying TLM (used to set display name for the cross-organization ACR image pull app registration)"
}

variable "location" {
    type = string
    description = "The location to deploy the TLM to"
}

variable "tags" {
    type = map(string)
    description = "The tags to apply to the resources"
}

variable "create_openai_service" {
    type = bool
    description = "Whether to create the OpenAI service"
    default = true
}

variable "openai_service_name" {
    type = string
    description = "The name of the OpenAI service resource If create_openai_service is false, this is used to lookup the OpenAI service"
    default = "tlm-openai"
}

variable "openai_service_resource_group_name" {
    type = string
    description = "The name of the resource group containing the OpenAI service. If create_openai_service is false, this is used to lookup the OpenAI service"
    default = null
}

variable "openai_deployments" {
    type = map(object({
        name = string
        model = string
        version = string
        format = string
        scale = string
        capacity = number
    }))
    description = "The cognitive deployments to create (only set if create_openai_service is true)"
    default = {}
}

variable "create_imagepull_app_registration" {
    type = bool
    description = "Whether to create the app registration for pulling TLM container images"
    default = true
}

variable "existing_imagepull_app_registration" {
    type = object({
        id = string
        client_id = string
        tenant_id = string
        password = string
    })
    description = "Details of an existing app registration to use for image pulls (only set if create_imagepull_app_registration is false)"
    default = null
}
