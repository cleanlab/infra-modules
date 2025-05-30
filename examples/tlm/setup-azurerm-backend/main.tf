provider "azurerm" {
  features {}
  subscription_id = "a47bf188-5236-4db5-bde5-16655f9d07ec"
}

locals {
    environment = "staging"
    resource_group_name = "tfstate-rg"

    tags = {
        environment = local.environment
        project = "tlm"
        terraform = "true"
    }
}

module "bootstrap" {
    source               = "git::https://github.com/cleanlab/infra-modules.git//tlm/bootstrap?ref=v1.0.0"
    resource_group_name  = local.resource_group_name
    location             = "eastus"
    environment          = local.environment
    storage_account_name = "tlmtfstate"
    container_name       = "tfstate"
    subscription_id      = data.azurerm_client_config.current.subscription_id
    tags                 = local.tags
}

data "azurerm_client_config" "current" {}

output "tf_identity_client_id" {
  value = module.bootstrap.azurerm_uami_client_id
}
