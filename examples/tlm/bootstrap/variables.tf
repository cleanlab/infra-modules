variable "environment" {
    type        = string
    description = "Environment name (e.g., staging, production)"
}

variable "location" {
    type = string
    description = "The location to deploy the TLM to"
}

variable "storage_account_name" {
    type = string
    description = "Name of the storage account managing the remote backend"
}

variable "container_name" {
    type = string
    description = "Name of the remote backend container"
}

variable "accessor_object_id" {
    type = string
    description = "Object ID of the app registration with permissions to the remote backend"
}
