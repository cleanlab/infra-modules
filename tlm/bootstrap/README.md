# Bootstrap Module

Terraform module which sets up prerequisite Azure remote backend resources that can be used by the [`infra`](../infra/) and [`app`](../app/) modules. 

This module is optional and will only need to be run once for initial setup, rather than being incorporated into a recurring workflow. Alternatively, you may create the necessary resources manually (especially if you would like to use another remote backend option, like Amazon S3, GCS, or HashiCorp Terraform Cloud).