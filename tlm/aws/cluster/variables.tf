variable "environment" {
  description = "The environment to deploy to"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy the cluster to"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets to deploy the cluster to"
  type        = list(string)
}

variable "tags" {
  description = "The tags to apply to the VPC and related resources"
  type        = map(string)
}
