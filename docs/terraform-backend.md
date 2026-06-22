# Terraform Backend Configuration

## Explanation
A **Terraform Backend** dictates where the `.tfstate` file is stored. By default, Terraform stores state locally. For production architectures, an S3 backend with DynamoDB locking is critical to prevent collaboration conflicts and data loss.

## The Bootstrap Flow
1. **Initial Local State:** When `terraform apply` is executed inside `bootstrap/`, Terraform manages the state of the S3 bucket and DynamoDB table locally on your machine.
2. **Remote State Generation:** After bootstrap, the S3 bucket and DynamoDB table exist in AWS.
3. **Environment Adoption:** Future environments (`environments/dev` and `environments/prod`) are configured to store their `.tfstate` in this S3 bucket, utilizing DynamoDB for atomic locking.

## Example Backend Configuration
In future phases, `environments/dev/backend.tf` will look like this:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-unique-tf-state-bucket-12345"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-unique-tf-state-lock"
    encrypt        = true
  }
}
```
