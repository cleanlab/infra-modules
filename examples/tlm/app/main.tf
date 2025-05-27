locals {
  tags = {
    environment = var.environment
    project = "tlm"
    terraform = "true"
  }
}

resource "azurerm_resource_group" "this" {
  name = var.resource_group_name
  location = var.location
  tags = local.tags
}

provider "azurerm" {
  features {}
  subscription_id = "a47bf188-5236-4db5-bde5-16655f9d07ec"
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
    source = "../../../tlm/app"

    environment = var.environment
    location = var.location
    app_version = var.app_version
    resource_group_name = azurerm_resource_group.this.name

    cluster_oidc_issuer_url = data.terraform_remote_state.infra.outputs.cluster_oidc_issuer_url
    openai_service_name = data.terraform_remote_state.infra.outputs.openai_service_name
    openai_service_resource_group_name = data.terraform_remote_state.infra.outputs.openai_service_resource_group_name

    image_pull_username = data.terraform_remote_state.infra.outputs.acr_image_pull_app_client_id
    image_pull_password = data.terraform_remote_state.infra.outputs.acr_image_pull_app_password

    default_completion_model = var.default_completion_model
    default_embedding_model = var.default_embedding_model

    tags = local.tags
}
