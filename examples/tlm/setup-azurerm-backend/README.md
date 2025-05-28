# Set up Azure remote backend

Configuration in this directory sets up the resources needed for Azure remote backend, using the [bootstrap](../../../tlm/bootstrap/) module.

This example should be used as a template, not an out-of-the-box solution. Certain values must be changed to adapt to your specific environment. See [bootstrap/variables.tf](../../../tlm/bootstrap/variables.tf) for descriptions of the module inputs.

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