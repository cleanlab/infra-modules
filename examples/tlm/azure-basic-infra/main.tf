provider "azurerm" {
  features {}
  subscription_id = "a47bf188-5236-4db5-bde5-16655f9d07ec"
}

locals {
    environment = "staging"
}

module "infra" {
    source = "../../../tlm/infra"

    environment = local.environment
    entity = "your-company-name"
    location = "eastus"

    create_openai_service = false
    openai_service_name = "tlm-openai"
    openai_service_resource_group_name = "tlm-staging-rg"
    
    create_imagepull_app_registration = false
    existing_imagepull_app_registration = {
        id = "/applications/c31c140c-1fbd-41c4-a088-428841cd560e"
        client_id = "c2a065ca-b62a-4647-9622-40cf283de0d1"
        tenant_id = "d3da5a95-4d1d-48aa-a0a6-87fe75942484"
        password = ""
    }

    default_completion_model = "azure/gpt-4o-mini"
    default_embedding_model = "azure/text-embedding-3-small"

    tags = {
        environment = local.environment
        project = "tlm"
        terraform = "true"
    }
}
