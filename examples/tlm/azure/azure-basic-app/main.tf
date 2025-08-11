locals {
  environment = "staging"
  resource_group_name = "tlm-staging-rg"
  subscription_id = "a47bf188-5236-4db5-bde5-16655f9d07ec"
  location = "eastus2"
  tags = {
    environment = local.environment
    project = "tlm"
    terraform = "true"
  }
}

import {
  to = azurerm_resource_group.this
  id = "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}"
}

resource "azurerm_resource_group" "this" {
  name = local.resource_group_name
  location = local.location
  tags = local.tags
}

provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.infra.outputs.kube_host
  client_certificate     = base64decode(data.terraform_remote_state.infra.outputs.kube_client_certificate)
  client_key             = base64decode(data.terraform_remote_state.infra.outputs.kube_client_key)
  cluster_ca_certificate = base64decode(data.terraform_remote_state.infra.outputs.kube_cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.infra.outputs.kube_host
    client_certificate     = base64decode(data.terraform_remote_state.infra.outputs.kube_client_certificate)
    client_key             = base64decode(data.terraform_remote_state.infra.outputs.kube_client_key)
    cluster_ca_certificate = base64decode(data.terraform_remote_state.infra.outputs.kube_cluster_ca_certificate)
  }
}

module "app" {
    source = "git::https://github.com/cleanlab/infra-modules.git//tlm/azure/app"

    environment = local.environment
    location = local.location
    app_version = "0.1.49"
    app_image_tag = "d4b6cc4b7a3e96cb37ce57e27fa37acfddf000c7"
    resource_group_name = azurerm_resource_group.this.name

    cluster_oidc_issuer_url = data.terraform_remote_state.infra.outputs.cluster_oidc_issuer_url
    openai_service_name = data.terraform_remote_state.infra.outputs.openai_service_name
    openai_service_resource_group_name = data.terraform_remote_state.infra.outputs.openai_service_resource_group_name

    image_pull_username = data.terraform_remote_state.infra.outputs.acr_image_pull_app_client_id
    image_pull_password = data.terraform_remote_state.infra.outputs.acr_image_pull_app_password

    default_completion_model = "azure/gpt-4.1-mini"
    lowest_latency_model = "azure/gpt-4.1-nano"

    enable_external_access = true
    model_config_file_path = "/Users/Kelsey/code/infra-modules/examples/tlm/azure-basic-app/models.json"

    tags = local.tags
}
