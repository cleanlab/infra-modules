# TLM Modules

Modules in this directory work together to create the resources required for deploying the Trustworthy Language Model (TLM). 

| Module | Description |
|--------|-------------|
| `bootstrap` | Initial setup of Azure remote backend resources and roles |
| `infra` | Management of Azure infrastructure resources required by the TLM app, including OpenAI services, Kubernetes cluster, and access to Cleanlab's Azure container registry for app images. |
| `app` | Deployment of the TLM application service into the Azure environment created by `infra` |

## Recommended workflow

1. Create Azure remote backend resources. This only needs to happen once for initial setup.

    **Option 1:** Using the `bootstrap` module

    ```
    module "bootstrap" {
        source = "git::https://github.com/cleanlab/infra-modules.git//tlm/bootstrap?ref=v1.0.0"

        ...
    }
    ```

    See [`bootstrap`](./bootstrap/), or refer to [`setup-azurerm-backend`](../examples/tlm/setup-azurerm-backend/) for a complete example.

    **Option 2:** Manually

    Alternatively, you may choose to set up the remote backend resources manually, especially if you would like to use another option instead of Azure. 

2. Run the `infra` module, writing outputs to the Azure remote backend. This may be incorporated into a CI pipeline for automatic updates. Call the module using this GitHub repository as the `source`. Release versions are tagged for convenience of updates.

    ```
    module "infra" {
        source = "git::https://github.com/cleanlab/infra-modules.git//tlm/infra?ref=v1.0.0"

        ...
    }
    ```
    See [`infra`](./infra/), or refer to or [`azure-basic-infra`](../examples/tlm/azure-basic-infra/) for a complete example, including how to configure writes to the remote backend via `backend.tf`.

3. Run the `app` module, reading from the Azure remote backend for shared state. This may be incorporated into a CI workflow for automated updates. Call the module using this GitHub repository as the `source`. Release versions are tagged for convenience of updates.

    ```
    module "app" {
        source = "git::https://github.com/cleanlab/infra-modules.git//tlm/app?ref=v1.0.0"

        ...
    }
    ```

    See [`app`](./app/), or refer to [`azure-basic-app`](../examples/tlm/azure-basic-app/) for a complete example, including how to read from the remote backend via `data.tf` and configuring the required providers.
