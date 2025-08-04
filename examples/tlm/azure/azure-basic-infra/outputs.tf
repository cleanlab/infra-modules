output "kube_host" {
    value = module.infra.kube_host
    sensitive = true
}

output "kube_client_certificate" {
    value = module.infra.kube_client_certificate
    sensitive = true
}

output "kube_client_key" {
    value = module.infra.kube_client_key
    sensitive = true
}

output "kube_cluster_ca_certificate" {
    value = module.infra.kube_cluster_ca_certificate
    sensitive = true
}

output "cluster_oidc_issuer_url" {
    value = module.infra.cluster_oidc_issuer_url
}

output "acr_image_pull_app_client_id" {
    value = module.infra.acr_image_pull_app_client_id
}

output "acr_image_pull_app_password" {
    value = module.infra.acr_image_pull_app_password
    sensitive = true
}

output "openai_service_name" {
    value = module.infra.openai_service_name
}

output "openai_service_resource_group_name" {
    value = module.infra.openai_service_resource_group_name
}
