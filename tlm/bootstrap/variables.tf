variable "resource_group_name" {
  type        = string
  description = "Resource group where backend state will live"
}

variable "environment" {
  type = string
  description = "Name of the environment where the resources are deployed"
}

variable "tags" {
    type = map(string)
    description = "The tags to apply to the resources"
}

variable "location" {
  type        = string
  description = "Azure location"
  default     = "eastus"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account for Terraform state"
}

variable "container_name" {
  type        = string
  default     = "tlm-infra-tfstate"
}

variable "accessor_object_id" {
  type        = string
  description = "Optional Azure AD object ID to grant access to backend state"
  default     = null
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID associated with the resources"
}
