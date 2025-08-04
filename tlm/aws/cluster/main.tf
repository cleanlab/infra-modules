module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "~> 20.34.0"

    cluster_name = "${var.environment}-tlm-app"
    cluster_version = "1.31"

    cluster_endpoint_public_access = true
    enable_cluster_creator_admin_permissions = false

    cluster_addons = {
        coredns = {}
        eks-pod-identity-agent = {}
        kube-proxy = {}
        vpc-cni = {
            service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
            addon_version = "v1.19.3-eksbuild.1"
        }
        aws-ebs-csi-driver = {
            service_account_role_arn = module.ebs_csi_irsa.iam_role_arn
        }
    }

    vpc_id = var.vpc_id
    subnet_ids = var.subnet_ids

    eks_managed_node_groups = {
      default = {
        ami_type       = "AL2023_x86_64_STANDARD"
        instance_types = ["m5.xlarge", "m5.2xlarge"]

        min_size = 2
        max_size = 5
        desired_size = 2

        tags = var.tags
      }
    }

    tags = var.tags
}

module "vpc_cni_irsa" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                       = "~> 5.0"

  role_name                     = "tlm-${var.environment}-vpc-cni"
  attach_vpc_cni_policy         = true
  vpc_cni_enable_ipv4           = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = var.tags
}

module "ebs_csi_irsa" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                       = "~> 5.0"

  role_name                     = "tlm-${var.environment}-ebs-csi"
  attach_ebs_csi_policy         = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = var.tags
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}
