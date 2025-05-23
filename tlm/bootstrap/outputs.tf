output "storage_account_name" {
  value = azurerm_storage_account.tf.name
}

output "container_name" {
  value = azurerm_storage_container.tf.name
}

output "resource_group_name" {
  value = var.resource_group_name
}

output "location" {
  value = var.location
}

output "azurerm_uami_client_id" {
  value = azurerm_user_assigned_identity.tf_identity.client_id
}
