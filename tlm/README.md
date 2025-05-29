# TLM Modules

Modules in this directory work together to create the resources required for deploying the Trustworthy Language Model (TLM). 

| Module | Description |
|--------|-------------|
| `bootstrap` | Initial setup of Azure remote backend resources and roles _(optional)_ |
| `infra` | Management of Azure infrastructure resources required by the TLM app, including OpenAI services, Kubernetes cluster, and access to Cleanlab's Azure container registry for app images. |
| `app` | Deployment of the TLM application service into the Azure environment created by `infra` |

## Recommended workflow

1. Create Azure remote backend resources. This only needs to happen once for initial setup.

    **Option 1:** Using the `bootstrap` module

    See [`bootstrap`](./bootstrap/) or the [`setup-azurerm-backend`](../examples/tlm/setup-azurerm-backend/) example.

    **Option 2:** Manually

    You may choose to set up the remote backend resources manually, especially if you would like to use another option instead of Azure. 

2. Run the `infra` module, writing outputs to the Azure remote backend. This may be incorporated into a CI pipeline for automatic updates.

    ```
    # main.tf

    module "infra" {
        source = "git::https://github.com/cleanlab/infra-modules.git//tlm/infra"

        environment = "staging"
        entity = "example-company"
        location = "eastus"

        create_openai_service = true
        openai_deployments = {
            "gpt-4o-mini" = {
                name = "gpt-4o-mini"
                model = "gpt-4o-mini"
                version = "2024-07-18"
                format = "OpenAI"
                scale = "GlobalStandard"
                capacity = 10
            }
            "text-embedding-3-small" = {
                name = "text-embedding-3-small"
                model = "text-embedding-3-small"
                version = "1"
                format = "OpenAI"
                scale = "Standard"
                capacity = 50
            }
        }
        
        create_imagepull_app_registration = true

        default_completion_model = "azure/gpt-4o-mini"
        default_embedding_model = "azure/text-embedding-3-small"

        tags = {
            environment = "staging"
            project = "tlm"
            terraform = "true"
        }
    }
    ```

    See [`azure-basic-infra/backend.tf`](../examples/tlm/azure-basic-infra/backend.tf) for an example of how to configure writes to the remote backend.

3. Run the `app` module, reading from the Azure remote backend for shared state. This may be incorporated into a CI workflow for automated updates.

    ```
    # main.tf

    locals {
        environment = "staging"
    }

    module "app" {
        source = "git::https://github.com/cleanlab/infra-modules.git//tlm/app"

        environment = local.environment
        location = "eastus"
        app_version = "0.1.46"
        resource_group_name = "tlm-staging-rg"

        cluster_oidc_issuer_url = data.terraform_remote_state.infra.outputs.cluster_oidc_issuer_url
        openai_service_name = data.terraform_remote_state.infra.outputs.openai_service_name
        openai_service_resource_group_name = data.terraform_remote_state.infra.outputs.openai_service_resource_group_name

        image_pull_username = data.terraform_remote_state.infra.outputs.acr_image_pull_app_client_id
        image_pull_password = data.terraform_remote_state.infra.outputs.acr_image_pull_app_password

        default_completion_model = "azure/gpt-4o-mini"
        default_embedding_model = "azure/text-embedding-3-small"

        tags = {
            environment = local.environment
            project = "tlm"
            terraform = "true"
        }
    }
    ```

    Note that the code above requires additional configuration and will NOT work as is. See [`azure-basic-app`](../examples/tlm/azure-basic-app/) for a complete example, including how to read from the remote backend via `data.tf` and configuring the required providers.