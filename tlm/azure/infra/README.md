# TLM Infra Module

Terraform module which creates the infrastructure resources required for the TLM application. 

## Requirements

There is a dependency between this module and the `app` module because `app` needs certain outputs from `infra`. In order to share values from `tfstate`, a remote backend is recommended. When calling this module, you can use a backend block to write state remotely. 

- See the [`bootstrap`](../bootstrap) to create the prerequisite remote backend resources in Azure.
- See [`azure-basic-infra/backend.tf`](../../examples/tlm/azure-basic-infra/backend.tf) for an example of how to configure the remote backend source when calling this module.