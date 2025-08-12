data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# IAM policy document for Bedrock access
data "aws_iam_policy_document" "bedrock_policy" {
  statement {
    sid    = "BedrockAccess"
    effect = "Allow"
    
    actions = [
      "bedrock:InvokeModel",
      "bedrock:InvokeModelWithResponseStream",
      "bedrock:InvokeModelWithInferenceProfile",
      "bedrock:ListFoundationModels",
      "bedrock:GetFoundationModel"
    ]
    
    resources = ["*"]
  }
}

# IAM policy for Bedrock access
resource "aws_iam_policy" "bedrock_policy" {
  name_prefix = "${var.release_name}-bedrock-"
  description = "Policy for TLM chat-backend to access AWS Bedrock"
  policy      = data.aws_iam_policy_document.bedrock_policy.json

  tags = {
    Application = var.release_name
    Component   = "chat-backend"
  }
}

# Trust policy for IRSA
data "aws_iam_policy_document" "trust_policy" {
  statement {
    effect = "Allow"
    
    principals {
      type        = "Federated"
      identifiers = [var.cluster_oidc_provider_arn]
    }
    
    actions = ["sts:AssumeRoleWithWebIdentity"]
    
    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }
    
    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# IAM role for the service account
resource "aws_iam_role" "chat_backend_role" {
  name_prefix        = "${var.release_name}-chat-backend-"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json

  tags = {
    Application = var.release_name
    Component   = "chat-backend"
  }
}

# Attach Bedrock policy to the role
resource "aws_iam_role_policy_attachment" "bedrock_policy_attachment" {
  role       = aws_iam_role.chat_backend_role.name
  policy_arn = aws_iam_policy.bedrock_policy.arn
}

# Create Kubernetes service account with IRSA annotation
resource "kubernetes_service_account" "chat_backend" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace
    
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.chat_backend_role.arn
    }
    
    labels = {
      "app.kubernetes.io/name"      = var.release_name
      "app.kubernetes.io/component" = "chat-backend"
    }
  }

  depends_on = [kubernetes_namespace.this]
}
