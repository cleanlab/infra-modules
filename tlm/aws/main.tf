locals {
  tags = {
    Environment = var.environment
    Project = "tlm"
    Terraform = "true"
  }
}

module "cluster" {
    source = "./cluster"
    environment = var.environment

    vpc_id = var.vpc_id
    subnet_ids = var.private_subnet_ids

    tags = local.tags
}