# Setup Instructions

Follow these exact steps chronologically to deploy this architecture on AWS.

## Step 1: Configure AWS CLI
Ensure you have the AWS CLI installed and configured with Administrator-level access.
```bash
aws configure
aws sts get-caller-identity
```

## Step 2: Deploy Bootstrap Layer
Provision the remote state storage (S3) and locking mechanism (DynamoDB).
```bash
cd bootstrap
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars to include a globally unique state_bucket_name

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

## Step 3: Configure Dev Backend
Once the bootstrap is complete, take the outputted `state_bucket_name` and `dynamodb_table_name` and update the placeholders in `environments/dev/backend.tf`. Be sure to uncomment the backend block!

## Step 4: Deploy Dev Environment (VPC + ALB + EC2 + RDS)
Initialize the dev environment with the newly configured remote backend, and proceed to build the networking, compute, and database resources.
```bash
cd ../environments/dev
cp terraform.tfvars.example terraform.tfvars

# VERY IMPORTANT: Open terraform.tfvars and change `db_password` to a strong local password.
# Never commit this file.

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

## Step 5: Test
When the apply completes, Terraform will output an `alb_dns_name` and a `db_endpoint`. 
Wait ~3 minutes for the EC2 instance to finish booting and passing health checks, then **open the `alb_dns_name` in your browser**. You should see the test page:
**"Terraform AWS Infrastructure - Dev Environment"**

## Step 6: Cleanup
Cloud resources cost money. When you are finished testing and capturing screenshots, destroy the dev environment:
```bash
# From within the environments/dev directory:
terraform destroy
```
(See `docs/cleanup.md` for full cleanup steps, including tearing down the bootstrap layer).
