data "terraform_remote_state" "infra" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tlmtestinfratfstate"
    container_name       = "tfstate"
    key                  = "tlm/infra/terraform.tfstate"
  }
}
