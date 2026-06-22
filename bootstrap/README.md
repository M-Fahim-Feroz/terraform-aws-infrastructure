# Terraform Bootstrap

## Overview
This folder contains the **bootstrap** layer of the Terraform project. It provisions the foundational infrastructure required to safely manage Terraform state remotely before any application infrastructure is built.

Specifically, it creates:
1. **Amazon S3 Bucket:** Stores the Terraform state (`.tfstate`) securely in the cloud.
2. **Amazon DynamoDB Table:** Provides state locking to ensure multiple team members or CI/CD pipelines do not overwrite the state simultaneously.

## Why is Remote State Needed?
Terraform uses a state file to map real-world resources to your configuration. Keeping this file local is dangerous because:
- If your laptop breaks or you delete the file, Terraform loses track of your AWS resources.
- Teams cannot collaborate because they don't share the same state file.
- Using an S3 bucket ensures the state is centralized, highly available, and backed up.

## Why is DynamoDB Locking Needed?
If two users (or CI/CD runs) execute `terraform apply` at the exact same time, they could corrupt the `.tfstate` file. DynamoDB acts as a lock mechanism: the first process acquires a lock, and the second process must wait until the lock is released.

## Security Features Included
- **S3 Versioning:** Protects against accidental deletion or corruption by retaining every version of the state file.
- **S3 Server-Side Encryption (AES256):** Secures the state file at rest.
- **S3 Public Access Block:** Explicitly prevents any public access to the state bucket.
- **Lifecycle Protection:** Uses `prevent_destroy = true` on the bucket and table to prevent accidental deletion via Terraform.

## Usage

### 1. Configure Variables
Copy the example variables file and adjust the values. **The S3 bucket name must be globally unique across all of AWS.**
```bash
cp terraform.tfvars.example terraform.tfvars
```

> ⚠️ **Warning:** Never commit `terraform.tfvars` to source control. It is ignored by `.gitignore` by default.

### 2. Run Terraform Commands
Initialize Terraform (this initial run uses local state):
```bash
terraform init
```

Format and validate the code:
```bash
terraform fmt
terraform validate
```

View the execution plan:
```bash
terraform plan
```

Apply the changes to AWS:
```bash
terraform apply
```

> ⚠️ **Cleanup Warning:** Do not casually destroy the bootstrap infrastructure! Once other environments (like `dev` or `prod`) are built, destroying this S3 bucket will instantly delete the state tracking for your entire architecture, causing severe issues.
