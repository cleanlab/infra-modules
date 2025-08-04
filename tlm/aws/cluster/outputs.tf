output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_oidc_arn" {
  value = module.eks.oidc_provider_arn
}

output "cluster_oidc_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_oidc_token" {
  value = data.aws_eks_cluster_auth.cluster.token
  sensitive = true
}
