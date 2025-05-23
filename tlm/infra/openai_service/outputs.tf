output "openai_endpoint_url" {
    value = var.create ? module.openai_service[0].endpoint : var.openai_endpoint_url
}

output "openai_service_name" {
    value = var.openai_service_name
}
