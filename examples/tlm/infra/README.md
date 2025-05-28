# Basic Infra

Configuration in this directory creates the infrastructure resources needed for the TLM VPC deployment, in a remote Azure environment, by using the [infra](./../../../tlm/infra/) module.

Note that values in [`main.tf`](./main.tf) should be modified or filled in as needed. The existing script will not work without changes.

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