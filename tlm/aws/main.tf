locals {
  tags = {
    Environment = var.environment
    Project = "tlm"
    Terraform = "true"
  }
}

module "cluster" {
    source = "./cluster"
    environment = var.environment

    vpc_id = var.vpc_id
    subnet_ids = var.private_subnet_ids

    tags = local.tags
    
    providers = {
        kubernetes = kubernetes.eks
    }
}

module "cluster_addons" {
    source = "./cluster-addons"
    environment = var.environment
    cluster_name = module.cluster.cluster_name
    cluster_oidc_provider_arn = module.cluster.cluster_oidc_arn
    cluster_oidc_issuer_url = module.cluster.cluster_oidc_url
    tags = local.tags
    
    depends_on = [module.cluster]
    
    providers = {
        helm = helm.eks
        kubernetes = kubernetes.eks
    }
}

module "app" {
    source = "./app"
    app_version = "0.1.52"
    app_image_tag = var.app_image_tag
    enable_external_access = true
    aws_region = var.aws_region
    openai_api_key_secret_name = var.openai_api_key_secret_name
    
    # Pass OIDC information for IRSA
    cluster_oidc_provider_arn = module.cluster.cluster_oidc_arn
    cluster_oidc_issuer_url = module.cluster.cluster_oidc_url

    depends_on = [module.cluster]

    providers = {
        aws = aws
        helm = helm.eks
        kubernetes = kubernetes.eks
    }
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = module.cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.cluster.cluster_certificate_authority_data)
    token                  = module.cluster.cluster_oidc_token
  }
}

provider "kubernetes" {
  alias = "eks"
  host                   = module.cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.cluster.cluster_certificate_authority_data)
  token                  = module.cluster.cluster_oidc_token
}
