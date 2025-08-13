output "kube_host" {
    value = module.cluster.kube_host
}

output "kube_client_certificate" {
    value = module.cluster.kube_client_certificate
}

output "kube_client_key" {
    value = module.cluster.kube_client_key
}

output "kube_cluster_ca_certificate" {
    value = module.cluster.kube_cluster_ca_certificate
}

output "cluster_oidc_issuer_url" {
    value = module.cluster.oidc_issuer_url
}

output "acr_image_pull_app_client_id" {
    value = module.acr_image_pull.app_reg_client_id
}

output "acr_image_pull_app_password" {
    value = module.acr_image_pull.app_reg_password
}

output "openai_service_name" {
    value = module.openai_service.openai_service_name
}

output "openai_service_resource_group_name" {
    value = module.openai_service.openai_service_resource_group_name
}
