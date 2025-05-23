resource "azurerm_kubernetes_cluster" "this" {
  name                = "tlm-${var.environment}-cluster"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "tlm-${var.environment}-cluster"

  default_node_pool {
    name       = "default"
    temporary_name_for_rotation = "temp"
    node_count = 2
    vm_size    = "Standard_D2as_v4"
  }

  identity {
    type = "SystemAssigned"
  }

  oidc_issuer_enabled = true
  workload_identity_enabled = true

  tags = var.tags

  lifecycle {
    ignore_changes = [
        default_node_pool[0].upgrade_settings
    ]
  }
}
