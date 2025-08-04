variable "entity" {
    type = string
    description = "The name of the entity deploying TLM (used to set display name for the cross-organization ACR image pull app registration)"
}

variable "existing_app_registration" {
    type = object({
        id = string
        client_id = string
        tenant_id = string
        password = string
    })
    description = "The existing app registration to use for image pulls, or null if the module should create a new app registration"
    default = null
}
