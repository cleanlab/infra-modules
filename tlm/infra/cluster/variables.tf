variable "environment" {
    type = string
    description = "The environment to deploy the TLM to"
}

variable "location" {
    type = string
    description = "The location to deploy the TLM to"
}

variable "resource_group_name" {
    type = string
    description = "The name of the resource group to deploy the TLM to"
}

variable "tags" {
    type = map(string)
    description = "The tags to apply to the resources"
}
