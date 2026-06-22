# Security Policies

Security is prioritized throughout the infrastructure code using DevSecOps principles.

## 1. Secrets Management
- No hardcoded AWS access keys or secret keys in `.tf` files.
- **Database Passwords:** `db_password` is flagged as `sensitive = true` within Terraform, meaning it will never be printed in CLI outputs. The master password must reside solely in a local `terraform.tfvars` file, which is aggressively ignored by `.gitignore`.

> ⚠️ **State File Security Note:** Terraform sensitive variables hide values in CLI output, but secrets may still exist in plaintext within the `terraform.tfstate` file. For production, you should use AWS Secrets Manager or SSM Parameter Store rather than passing passwords directly through Terraform variables.

## 2. Compute Security (No SSH)
- **Zero SSH Architecture:** We do not provision SSH key pairs or open port 22 on any instances. All administrative access to EC2 instances is governed by the `AmazonSSMManagedInstanceCore` IAM policy. This enables AWS Systems Manager Session Manager for secure, auditable terminal sessions.

## 3. Network Security
- **Private Subnet Isolation:** EC2 and RDS instances sit entirely in Private Subnets with no public IPs, completely disconnected from inbound public internet.
- **Public Subnet Routing:** Only Public Subnets have direct `0.0.0.0/0` outbound routes. Private Subnets rely entirely on the NAT Gateway.
- **Strict Security Groups:** The ALB accepts traffic from `0.0.0.0/0`. The EC2 instance accepts traffic **only** from the ALB Security Group. The RDS Database accepts traffic **only** from the EC2 Security Group on port 5432.

## 4. Storage Security
- Terraform state buckets are configured with **Public Access Block** completely restricting anonymous data exposure.
- **Server-Side Encryption (AES256)** is enforced on S3 buckets.
- **RDS Storage Encryption:** `storage_encrypted = true` is mandated on the PostgreSQL instance.

## 5. Deletion Protections
- In the `dev` environment, `deletion_protection = false` and `skip_final_snapshot = true` are configured to allow rapid teardowns. In production equivalents, these must be reversed to prevent data loss.

## 6. CI/CD Scanning
- Infrastructure as Code is statically analyzed using **Checkov** to prevent the deployment of non-compliant resources.
