# Basic App Deployment

Configuration in this directory deploys the TLM application service in a remote Azure environment, by using the [app](../../../tlm/app/) module.

Note that values in [`main.tf`](./main.tf) and [`data.tf`](./data.tf) must be modified to match your environment. 

## Prerequisites

The `app` module depends on resources in the `infra` module. See [`azure-basic-infra`](../azure-basic-infra/) for an example of how to create the necessary resources.

## Usage

To run this example, follow these steps:

1. Update or modify the values in `main.tf` to match your environment. Make sure to set the ID of your resource group in the corresponding `import` block.
    ```
    import {
        to = azurerm_resource_group.this
        id = "/subscriptions/<your-subscription-id>/resourceGroups/<your-rg>"
    }
    ```
3. Run these commands in CLI:
    ```
    $ terraform init
    $ terraform plan
    $ terraform apply
    ```
If you no longer need these resources, you may run `terraform destroy`.