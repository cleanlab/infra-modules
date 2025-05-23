resource azurerm_user_assigned_identity "openai_identity_sa" {
    name = "tlm-${var.environment}-openai-service-identity"
    resource_group_name = var.resource_group_name
    location = var.location

    tags = var.tags
}

resource azurerm_role_assignment "openai_identity_sa" {
    principal_id = azurerm_user_assigned_identity.openai_identity_sa.principal_id
    scope = data.azurerm_cognitive_account.openai_service.id
    role_definition_name = "Cognitive Services OpenAI User"
}

resource azurerm_federated_identity_credential "openai_identity_sa" {
    name = azurerm_user_assigned_identity.openai_identity_sa.name
    resource_group_name = var.resource_group_name
    parent_id = azurerm_user_assigned_identity.openai_identity_sa.id
    audience = ["api://AzureADTokenExchange"]
    issuer = var.cluster_oidc_issuer_url
    subject = "system:serviceaccount:${local.namespace}:${local.service_account_name}"
}

resource kubernetes_service_account "openai_identity_sa" {
    metadata {
        name = local.service_account_name
        namespace = local.namespace
        annotations = {
            "azure.workload.identity/client-id" = azurerm_user_assigned_identity.openai_identity_sa.client_id
            "azure.workload.identity/service-account-token-expiration" = "86400"
        }
        labels = {
            "azure.workload.identity/use" = "true"
        }
    }

    depends_on = [
        kubernetes_namespace.this
    ]
}
