resource "azurerm_resource_group" "this" {
    name = var.resource_group_name
    location = var.location

    tags = var.tags
}

resource "azurerm_storage_account" "tf" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_storage_container" "tf" {
  name                  = var.container_name
  storage_account_id    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Storage/storageAccounts/${var.storage_account_name}"
  container_access_type = "private"

  depends_on = [azurerm_resource_group.this, azurerm_storage_account.tf]
}

resource "azurerm_user_assigned_identity" "tf_identity" {
  name                = "terraform-uami"
  location            = var.location
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_role_assignment" "tfstate_access" {
  count                = var.accessor_object_id != null ? 1 : 0
  principal_id         = azurerm_user_assigned_identity.tf_identity.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.tf.id
}
