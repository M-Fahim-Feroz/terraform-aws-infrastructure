# Runbook — Terraform AWS Infrastructure

## Initial Setup

```bash
# 1. Configure AWS credentials
aws configure

# 2. Bootstrap remote state (first time only)
cd environments/dev
terraform init
terraform apply  # creates S3 bucket + DynamoDB

# 3. Migrate to remote backend
terraform init -migrate-state
```

## Plan Changes

```bash
cd environments/dev
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_REGION=us-east-1
terraform plan
```

## Apply Changes (Manual)

```bash
terraform apply
# Or via GitHub Actions:
# Actions → Terraform Apply (Manual) → Run workflow → type APPLY
```

## View Outputs

```bash
terraform output
# Example outputs: ALB DNS name, EC2 instance IDs, RDS endpoint
```

## Destroy Everything

> [!CAUTION]
> This permanently deletes all AWS resources.

```bash
terraform destroy
# Confirm with: yes
```

## Common Commands

```bash
terraform fmt -recursive        # format all .tf files
terraform validate              # validate configuration
terraform state list            # list all managed resources
terraform state show <resource> # show details of a resource
terraform import <resource> <id> # import existing AWS resource
```
