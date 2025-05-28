provider "azurerm" {
  features {}
}

locals {
    environment = "staging"
    resource_group_name = "tfstate-rg"
    storage_account_name = "tlmtestinfratfstate"

    tags = {
        environment = local.environment
        project = "tlm"
        terraform = "true"
    }
}

module "bootstrap" {
    source               = "../../../tlm/bootstrap"
    resource_group_name  = local.resource_group_name
    location             = "eastus"
    environment          = local.environment
    storage_account_name = local.storage_account_name
    storage_account_id   = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Storage/storageAccounts/${local.storage_account_name}"
    container_name       = "tfstate"
    accessor_object_id   = "b0ae2faf-4ecc-44ad-bcd7-b9462845640e"
    tags                 = local.tags
}

data "azurerm_client_config" "current" {}

output "tf_identity_client_id" {
  value = module.bootstrap.azurerm_uami_client_id
}
