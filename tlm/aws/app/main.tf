locals {
    # Default Bedrock models configuration
    default_models = {
        "bedrock/us.anthropic.claude-3-haiku-20240307-v1:0" = {
            api_base = "https://bedrock-runtime.us-west-2.amazonaws.com"
            api_version = "2023-09-30"
            inference_profile_arn = "arn:aws:bedrock:us-west-2:043170249292:inference-profile/us.anthropic.claude-3-haiku-20240307-v1:0"
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

    depends_on = [kubernetes_namespace.this, kubernetes_service_account.chat_backend]

    # Configure service account with IRSA (uses existing Helm chart functionality)
    set {
        name = "chat_backend.service_account"
        value = kubernetes_service_account.chat_backend.metadata[0].name
    }

    # Add AWS environment variables through existing defaults mechanism
    set {
        name = "chat_backend.defaults.AWS_DEFAULT_REGION"
        value = var.aws_region
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
