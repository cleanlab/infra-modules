# TLM App Module

Terraform module which creates the TLM application service deployment, using the Helm provider.

## Requirements

This module depends on the [`infra`](../infra/) module. These modules are distinct for separation of responsibilities, but there are outputs from `infra` that are needed by this `app` module. In order to share values from `tfstate`, a remote backend is recommended. When calling this module, you can use a data block to read state from the remote backend source. See [`azure-basic-app/data.tf`](../../examples/tlm/azure-basic-app/data.tf) for an example.