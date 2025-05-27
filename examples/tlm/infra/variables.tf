variable "environment" {
    type = string
    description = "Environment name (e.g. staging, production)"
}

variable "location" {
    type = string
    description = "The location to deploy the TLM to"
}

variable "entity" {
    type = string
    description = "Name of the owning entity (e.g. Cleanlab)"
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
