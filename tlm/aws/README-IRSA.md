# AWS IAM Roles for Service Accounts (IRSA) Setup

This document explains how the TLM AWS deployment creates and configures IAM Roles for Service Accounts (IRSA) to resolve the boto3 dependency error.

## Problem Solved

The error you encountered:
```
litellm.APIConnectionError: No module named 'boto3'
```

This happens because:
1. The TLM application tries to use AWS Bedrock
2. litellm requires boto3 for AWS service calls
3. The Kubernetes pod needs AWS credentials to make API calls

## Solution: IRSA Configuration (Terraform-Only)

The Terraform configuration automatically:

1. **Creates an IAM Role** with Bedrock permissions
2. **Creates a Kubernetes Service Account** with IRSA annotation  
3. **Configures the Helm release** to use the service account and AWS environment variables
4. **No Helm chart modifications required** - uses existing functionality

## What Gets Created

### 1. IAM Policy (`aws_iam_policy.bedrock_policy`)
Grants permissions for:
- `bedrock:InvokeModel`
- `bedrock:InvokeModelWithResponseStream`
- `bedrock:ListFoundationModels`
- `bedrock:GetFoundationModel`

### 2. IAM Role (`aws_iam_role.chat_backend_role`)
- Trust policy allows EKS service account to assume the role
- Attached to the Bedrock policy
- Naming: `{release_name}-chat-backend-{random}`

### 3. Kubernetes Service Account (`kubernetes_service_account.chat_backend`)
- Name: `tlm-chat-backend` (configurable)
- Namespace: `tlm` (or your configured namespace)
- Annotation: `eks.amazonaws.com/role-arn` pointing to the IAM role

### 4. Helm Configuration
Automatically sets (using existing Helm chart functionality):
- `chat_backend.service_account = tlm-chat-backend`
- `chat_backend.defaults.AWS_DEFAULT_REGION = {your_aws_region}`
- `chat_backend.defaults.LITELLM_BEDROCK_ENABLED = true`

## Deployment Process

### 1. Apply Terraform
```bash
cd /path/to/infra-modules/tlm/aws
terraform plan
terraform apply
```

### 2. Verify Service Account
```bash
kubectl get sa tlm-chat-backend -n tlm -o yaml
```

Should show:
```yaml
metadata:
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/tlm-chat-backend-xyz
```

### 3. Verify Pod Configuration
```bash
kubectl get pod -n tlm -l app.kubernetes.io/component=chat-backend -o yaml
```

Should show:
- `serviceAccountName: tlm-chat-backend`
- Environment variables: `AWS_DEFAULT_REGION`, `LITELLM_BEDROCK_ENABLED` (from configMap)

### 4. Test boto3 Availability
```bash
kubectl exec -it deployment/tlm-chat-backend -n tlm -- python -c "import boto3; print('boto3 available')"
```

## Configuration Variables

### Required Variables (automatically passed from cluster module):
- `cluster_oidc_provider_arn`: EKS cluster OIDC provider ARN
- `cluster_oidc_issuer_url`: EKS cluster OIDC issuer URL

### Optional Variables:
- `service_account_name`: Name of K8s service account (default: "tlm-chat-backend")
- `aws_region`: AWS region for Bedrock (inherited from parent)
- `release_name`: Helm release name (inherited from parent)

## Outputs

After deployment, you can access:
- `service_account_name`: Name of the created service account
- `iam_role_arn`: ARN of the IAM role
- `iam_role_name`: Name of the IAM role

## Troubleshooting

### 1. IRSA Not Working
Check the trust relationship on the IAM role:
```bash
aws iam get-role --role-name {role_name}
```

### 2. Permissions Issues
Verify the policy is attached:
```bash
aws iam list-attached-role-policies --role-name {role_name}
```

### 3. Pod Can't Assume Role
Check pod logs and AWS CloudTrail for assume role events:
```bash
kubectl logs deployment/tlm-chat-backend -n tlm
```

### 4. Environment Variables Missing
Verify Helm values were applied:
```bash
helm get values tlm -n tlm
```

## Security Notes

- The IAM role can only be assumed by the specific service account in the specific namespace
- Bedrock permissions are scoped to the minimum required actions
- No long-lived AWS credentials are stored in the cluster
- Role assumption is handled automatically by AWS IAM and EKS

## Next Steps

After successful deployment:
1. Monitor CloudWatch logs for any AWS API errors
2. Consider adding additional AWS service permissions if needed
3. Set up monitoring for IAM role usage in CloudTrail
4. Review and adjust Bedrock model permissions as needed