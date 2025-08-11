locals {
    # Default Bedrock models configuration
    default_models = {
        "gpt-4o-mini" = {
            api_base = "https://bedrock-runtime.${var.aws_region}.amazonaws.com"
            api_version = "2024-07-18"
        }
        "gpt-4o-nano" = {
            api_base = "https://bedrock-runtime.${var.aws_region}.amazonaws.com"
            api_version = "2024-07-18"
        }
    }
    
    # Use custom models if provided, otherwise use defaults
    models_json = var.model_config_file_path != null ? jsondecode(file(var.model_config_file_path)) : local.default_models
}

resource helm_release "this" {
    name = var.release_name
    namespace = var.namespace
    chart = "tlm"
    repository = "https://cleanlab.github.io/helm-charts/"
    version = var.app_version

    depends_on = [kubernetes_namespace.this]

    # in AWS, use EKS node group default permissions to pull images from ECR repo in same account
    # TODO: optionally create IRSA if cross-account
    set {
        name = "imagePullSecret.enabled"
        value = false
    }

    set {
        name = "chat_backend.image.repository"
        value = "${var.registry_server}/${var.registry_name}"
    }

    set {
        name = "chat_backend.image.tag"
        value = coalesce(var.app_image_tag, var.app_version)
    }

    set {
        name = "chat_backend.defaults.TLM_DEFAULT_MODEL_API_BASE"
        value = "https://bedrock-runtime.us-east-2.amazonaws.com"
    }

    set {
        name = "chat_backend.defaults.TLM_DEFAULT_COMPLETION_MODEL"
        value = var.default_completion_model
    }

    set {
        name = "chat_backend.models"
        value = yamlencode(local.models_json)
    }

    set {
        name = "chat_backend.defaults.LOWEST_LATENCY_MODEL"
        value = var.lowest_latency_model
    }

    set {
        name = "chat_backend.service.type"
        value = var.enable_external_access ? "LoadBalancer" : "ClusterIP"
    }
}
