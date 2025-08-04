# Basic Infra

Configuration in this directory creates the infrastructure resources needed for the TLM VPC deployment, in a remote Azure environment, by using the [infra](./../../../tlm/infra/) module.

Note that values in [`main.tf`](./main.tf) and [`backend.tf`](./backend.tf) should be modified or filled in as needed. The existing script will not work without changes.

## Prerequisites

This script requires a remote backend source. See [`setup-azurerm-backend`](../setup-azurerm-backend/) for an example script. If using the example, make sure to run [`set_uami_environment.sh`](../setup-azurerm-backend/set_uami_environment.sh) so that the user-assigned managed identity is used by Terraform CLI commands.

## Usage

To run this example, follow these steps:

1. Update or modify the values in `main.tf` to match your environment.
2. Run these commands in CLI:
    ```
    $ terraform init
    $ terraform plan
    $ terraform apply
    ```

If you no longer need these resources, you may run `terraform destroy`.