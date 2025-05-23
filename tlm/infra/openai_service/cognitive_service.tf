module "openai_service" {
  count = var.create ? 1 : 0
  source  = "Azure/avm-res-cognitiveservices-account/azurerm"
  version = "0.6.0"

  kind = "OpenAI"
  location = var.location
  resource_group_name = var.resource_group_name
  name = var.openai_service_name
  sku_name = "S0"

  tags = var.tags

  cognitive_deployments = {
    for deployment in var.cognitive_deployments : deployment.name => {
        name = deployment.name
        model = {
            format = deployment.format
            name = deployment.model
            version = deployment.version
        }
        scale = {
            type = deployment.scale
            capacity = deployment.capacity
        }
    }
  }
}
