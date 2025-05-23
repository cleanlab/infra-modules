resource helm_release "this" {
    name = local.release_name
    namespace = local.namespace
    chart = "tlm"
    repository = "oci://tlmcleanlab.azurecr.io/tlm"

    version = var.app_version

    repository_username = var.image_pull_username
    repository_password = var.image_pull_password

    set {
        name = "imagePullSecret.enabled"
        value = true
    }

    set {
        name = "imagePullSecret.name"
        value = local.image_pull_secret_name
    }

    set {
        name = "chat_backend.image.repository"
        value = "tlmcleanlab.azurecr.io/tlm/chat-backend"
    }

    set {
        name = "chat_backend.service_account"
        value = kubernetes_service_account.openai_identity_sa.metadata[0].name
    }

    set {
        name = "chat_backend.defaults.TLM_DEFAULT_MODEL_API_BASE"
        value = data.azurerm_cognitive_account.openai_service.endpoint
    }

    set {
        name = "chat_backend.defaults.TLM_DEFAULT_COMPLETION_MODEL"
        value = var.default_completion_model
    }

    set {
        name = "chat_backend.defaults.TLM_DEFAULT_EMBEDDING_MODEL"
        value = var.default_embedding_model
    }
}
