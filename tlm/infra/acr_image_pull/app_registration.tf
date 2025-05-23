data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "msgraph" {
  count    = var.existing_app_registration == null ? 1 : 0
  client_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]
}

locals {
  app_registration_id = var.existing_app_registration != null ? var.existing_app_registration.id : azuread_application_registration.this[0].id
  app_password = var.existing_app_registration != null ? var.existing_app_registration.password : azuread_application_password.this[0].value
  msgraph_app_role_ids = var.existing_app_registration == null ? data.azuread_service_principal.msgraph[0].app_role_ids : {}
}

resource azuread_application_registration "this" {
    count = var.existing_app_registration == null ? 1 : 0
    display_name = "${var.entity} - TLM Cross-organization ACR Image Pull"
    sign_in_audience = "AzureADMultipleOrgs"
}

resource azuread_application_api_access "this" {
    count = var.existing_app_registration == null ? 1 : 0
    application_id = local.app_registration_id
    api_client_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]

    role_ids = [
        local.msgraph_app_role_ids["Application.Read.All"]
    ]
}

resource azuread_application_password "this" {
    count = var.existing_app_registration == null ? 1 : 0
    application_id = local.app_registration_id
}
