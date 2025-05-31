provider "azurerm" {
  features {}
  subscription_id = "a47bf188-5236-4db5-bde5-16655f9d07ec"
}

locals {
    environment = "staging"
}

module "infra" {
    source = "git::https://github.com/cleanlab/infra-modules.git//tlm/infra?ref=v1.0.1"

    environment = local.environment
    entity = "your-company-name"
    location = "eastus"

    create_openai_service = true
    openai_deployments = {
        "gpt-4o-mini" = {
            name = "gpt-4o-mini"
            model = "gpt-4o-mini"
            version = "2024-07-18"
            format = "OpenAI"
            scale = "GlobalStandard"
            capacity = 10
        }
        "text-embedding-3-small" = {
            name = "text-embedding-3-small"
            model = "text-embedding-3-small"
            version = "1"
            format = "OpenAI"
            scale = "Standard"
            capacity = 50
        }
    }
    
    create_imagepull_app_registration = true

    default_completion_model = "azure/gpt-4o-mini"
    default_embedding_model = "azure/text-embedding-3-small"

    tags = {
        environment = local.environment
        project = "tlm"
        terraform = "true"
    }
}
