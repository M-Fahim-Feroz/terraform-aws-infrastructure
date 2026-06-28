# Troubleshooting Guide — Terraform AWS Infrastructure

## Terraform Issues

### `terraform init` fails — backend not found

The S3 bucket or DynamoDB table for remote state does not exist yet. Run the bootstrap:

```bash
cd environments/dev
terraform init  # use local backend first
terraform apply  # this creates the S3 bucket and DynamoDB table
# Then switch to remote backend and run terraform init -migrate-state
```

### `Error: state lock` — state is locked

```bash
# Find the lock ID from the error message, then force-unlock:
terraform force-unlock <LOCK_ID>
```

### `Error: error configuring S3 Backend` — access denied

Verify your IAM user/role has `s3:GetObject`, `s3:PutObject`, and `dynamodb:PutItem` permissions on the backend resources.

### Terraform plan shows destructive changes

> [!CAUTION]
> Never apply destructive changes without understanding them.

```bash
terraform plan -destroy  # review what would be destroyed
# Only apply if you intend to delete resources
```

### EC2 instance not reachable

Instances are in private subnets — there is no SSH access by design. Use AWS Systems Manager:

```bash
aws ssm start-session --target <instance-id>
```

### ALB health check failing

```bash
# Check target group health in AWS Console:
# EC2 → Load Balancers → Target Groups → <your-tg> → Targets
# Or with CLI:
aws elbv2 describe-target-health --target-group-arn <arn>
```

### RDS connection refused from EC2

- Verify the EC2 security group allows outbound to the RDS port (5432).
- Verify the RDS security group allows inbound from the EC2 security group.

## GitHub Actions Issues

### Terraform plan workflow fails — credentials not found

Verify these GitHub Secrets are set:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

### Manual apply workflow does not trigger

- The apply workflow only runs on `workflow_dispatch`.
- You must type `APPLY` exactly in the confirmation field.
- The `terraform-apply` GitHub Environment must exist in your repo settings.
