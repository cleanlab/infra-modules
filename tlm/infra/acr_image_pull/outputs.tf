output "app_reg_client_id" {
    value = var.existing_app_registration != null ? var.existing_app_registration.client_id : azuread_application_registration.this[0].client_id
}

output "app_reg_tenant_id" {
    value = var.existing_app_registration != null ? var.existing_app_registration.tenant_id : azuread_application_registration.this[0].object_id
}

output "app_reg_password" {
    value = local.app_password
    sensitive = true
}
