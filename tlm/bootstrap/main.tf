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
}

resource "azurerm_storage_container" "tf" {
  name                  = var.container_name
  storage_account_id    = var.storage_account_id
  container_access_type = "private"
}

resource "azurerm_user_assigned_identity" "tf_identity" {
  name                = "terraform-uami"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "tfstate_access" {
  count                = var.accessor_object_id != null ? 1 : 0
  principal_id         = azurerm_user_assigned_identity.tf_identity.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.tf.id
}
