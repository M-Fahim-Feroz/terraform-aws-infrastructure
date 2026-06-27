# Terraform State Backend

## Overview

This project uses a **remote S3 backend** for Terraform state with **DynamoDB locking**. The backend infrastructure is managed separately in the `bootstrap/` directory.

## Bootstrap Layer

The `bootstrap/` directory creates the backend resources:

```bash
cd bootstrap
terraform init
terraform apply
```

This provisions:
- **S3 bucket** — stores the Terraform state file
- **S3 bucket versioning** — keeps history of state changes for rollback
- **S3 server-side encryption** — AES-256 encryption at rest
- **S3 public access block** — prevents accidental public exposure of state
- **DynamoDB table** — provides state locking to prevent concurrent modifications

> ⚠️ **Bootstrap resources should not be destroyed after setup.** Destroying the S3 bucket would lose the Terraform state for all environments.

## Remote Backend Configuration

The `environments/dev/` backend configuration references the bootstrap resources:

```hcl
terraform {
  backend "s3" {
    bucket         = "<BOOTSTRAP_S3_BUCKET_NAME>"
    key            = "dev/terraform.tfstate"
    region         = "<AWS_REGION>"
    dynamodb_table = "<BOOTSTRAP_DYNAMODB_TABLE>"
    encrypt        = true
  }
}
```

## State Locking

DynamoDB provides state locking. When `terraform apply` or `terraform plan` runs:
1. Terraform acquires a lock on the DynamoDB table.
2. Other Terraform operations are blocked until the lock is released.
3. This prevents two pipeline runs from modifying the same state simultaneously.

## Security

| Feature | Status |
|---|---|
| S3 encryption at rest | ✅ Enabled |
| S3 public access block | ✅ Enabled |
| S3 versioning | ✅ Enabled |
| DynamoDB state locking | ✅ Enabled |
| State file in .gitignore | ✅ Confirmed |

## State Cleanup Warning

> [!CAUTION]
> The bootstrap layer (S3 bucket and DynamoDB table) must NOT be destroyed while environments that depend on it still exist. Always destroy environments first (`cd environments/dev && terraform destroy`), then destroy bootstrap (`cd bootstrap && terraform destroy`) only after all state is migrated or environments are fully destroyed.

## Risks of Local State

If using local state (without the S3 backend):
- State is lost when the machine or CI runner is reset.
- No locking means concurrent runs can corrupt state.
- No state history makes rollback difficult.

The remote backend eliminates all of these risks.
