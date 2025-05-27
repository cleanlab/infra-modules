provider "azurerm" {
  features {}
}

locals {
    environment = var.environment
    entity = var.entity
    location = var.location

    tags = {
        environment = local.environment
        project = "tlm"
        terraform = "true"
    }
}

module "infra" {
    source = "../../../tlm/infra"

    environment = local.environment
    entity = local.entity
    location = local.location

    create_openai_service = false
    openai_service_name = "tlm-openai"
    openai_service_resource_group_name = "tlm-staging-rg"
    
    create_imagepull_app_registration = false
    existing_imagepull_app_registration = var.existing_imagepull_app_registration

    default_completion_model = "azure/gpt-4o-mini"
    default_embedding_model = "azure/text-embedding-3-small"

    tags = local.tags
}
