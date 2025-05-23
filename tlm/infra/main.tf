resource "azurerm_resource_group" "this" {
    name = "tlm-${var.environment}-rg"
    location = var.location

    tags = var.tags
}

module "acr_image_pull" {
    source = "./acr_image_pull"

    entity = var.entity
    existing_app_registration = var.create_imagepull_app_registration ? null : var.existing_imagepull_app_registration
}

locals {
    openai_service_resource_group_name = var.create_openai_service ? azurerm_resource_group.this.name : var.openai_service_resource_group_name
}

module "openai_service" {
    source = "./openai_service"

    environment = var.environment
    location = var.location
    resource_group_name = local.openai_service_resource_group_name

    create = var.create_openai_service
    openai_service_name = var.openai_service_name
    cognitive_deployments = var.openai_deployments

    tags = var.tags
}

module "cluster" {
    source = "./cluster"

    environment = var.environment
    location = var.location
    resource_group_name = azurerm_resource_group.this.name

    tags = var.tags
}

provider "kubernetes" {
  host                   = module.cluster.kube_host
  client_certificate     = base64decode(module.cluster.kube_client_certificate)
  client_key             = base64decode(module.cluster.kube_client_key)
  cluster_ca_certificate = base64decode(module.cluster.kube_cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.cluster.kube_host
    client_certificate     = base64decode(module.cluster.kube_client_certificate)
    client_key             = base64decode(module.cluster.kube_client_key)
    cluster_ca_certificate = base64decode(module.cluster.kube_cluster_ca_certificate)
  }
}
