# Cleanup Instructions

Cloud infrastructure accrues billing costs. Follow these steps carefully to cleanly destroy the environment.

## Cost Warnings
> ⚠️ **Dev Environment Costs:** As long as the `dev` environment is deployed, AWS bills you for:
> 1. **NAT Gateway:** ~$32/month.
> 2. **Application Load Balancer:** Hourly rates + LCU charges.
> 3. **EC2 Instance:** Hourly rates for the `t3.micro`.
> 4. **RDS Database:** Hourly rates for the `db.t3.micro` instance + storage.
>
> **DESTROY THE DEV ENVIRONMENT AFTER TESTING TO AVOID CHARGES.** If you are not actively working on this project, destroy the dev environment immediately!
> Note: For `dev`, `skip_final_snapshot = true` is set, meaning your RDS data will be wiped instantly upon destruction.

## 1. Destroy Environments First
Never delete the bootstrap layer before destroying the application environments. If you do, Terraform loses its remote state and cannot automatically destroy the VPC, EC2, or RDS resources.

```bash
cd environments/dev
terraform destroy -auto-approve
```
Repeat for the `prod` environment if provisioned.

## 2. Disable `prevent_destroy` (If Necessary)
The `bootstrap/` layer includes `prevent_destroy = true` lifecycles on the S3 bucket and DynamoDB table. To destroy them, you must temporarily remove or comment out those lifecycle blocks in `bootstrap/main.tf`.

## 3. Empty the S3 Bucket
Terraform cannot delete an S3 bucket that contains objects. You must delete all state versions from the bucket manually via the AWS Console or AWS CLI.

## 4. Destroy Bootstrap
Once empty and unprotected, run:
```bash
cd bootstrap
terraform destroy
```
