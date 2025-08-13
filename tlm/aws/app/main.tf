locals {
    # Default Bedrock models configuration
    default_models = {
        "bedrock/us.anthropic.claude-3-haiku-20240307-v1:0" = {
            api_base = "https://bedrock-runtime.${var.aws_region}.amazonaws.com"
            api_version = "2023-09-30"
        }
    }
    
    # Use custom models if provided, otherwise use defaults
    models_json = var.model_config_file_path != null ? jsondecode(file(var.model_config_file_path)) : local.default_models
}

data "aws_secretsmanager_secret" "openai_api_key" {
  name = var.openai_api_key_secret_name
  provider = aws
}

data "aws_secretsmanager_secret_version" "openai_api_key" {
  secret_id = data.aws_secretsmanager_secret.openai_api_key.id
  provider = aws
}

locals {
  secret_json = jsondecode(data.aws_secretsmanager_secret_version.openai_api_key.secret_string)
  openai_api_key = local.secret_json["OPENAI_API_KEY"]
}

resource helm_release "this" {
    name = var.release_name
    namespace = var.namespace
    chart = "tlm"
    repository = "https://cleanlab.github.io/helm-charts/"
    version = var.app_version

    depends_on = [kubernetes_namespace.this, kubernetes_service_account.chat_backend]

    # Configure service account with IRSA (uses existing Helm chart functionality)
    set {
        name = "chat_backend.service_account"
        value = kubernetes_service_account.chat_backend.metadata[0].name
    }

    set {
        name = "chat_backend.aws_region"
        value = var.aws_region
    }

    set_sensitive {
        name = "chat_backend.defaults.OPENAI_API_KEY"
        value = local.openai_api_key
    }

    # in AWS, use EKS node group default permissions to pull images from ECR repo in same account
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

    # deliberately exclude TLM_DEFAULT_MODEL_API_BASE and set defaults at the provider level instead

    set {
        name = "chat_backend.defaults.TLM_DEFAULT_MODEL_API_BASE_BEDROCK"
        value = var.bedrock_endpoint
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
