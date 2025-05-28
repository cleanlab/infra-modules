provider "azurerm" {
  features {}
}

locals {
    resource_group_name = "tlm-${var.environment}-rg"

    tags = {
        environment = var.environment
        project = "tlm"
        terraform = "true"
    }
}

module "bootstrap" {
    source               = "../../../tlm/bootstrap"
    resource_group_name  = local.resource_group_name
    location             = var.location
    environment          = var.environment
    storage_account_name = var.storage_account_name
    storage_account_id   = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Storage/storageAccounts/${var.storage_account_name}"
    container_name       = var.container_name
    accessor_object_id   = var.accessor_object_id
    tags                 = local.tags
}

data "azurerm_client_config" "current" {}

output "tf_identity_client_id" {
  value = module.bootstrap.azurerm_uami_client_id
}
