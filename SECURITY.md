# Security Policy

## Reporting a Vulnerability

This is a portfolio project. For security issues:

1. Do not open a public GitHub issue.
2. Contact: [M-Fahim-Feroz](https://github.com/M-Fahim-Feroz)

## Security Design

- **No secrets committed** — AWS credentials, Terraform state, and `.tfvars` files are excluded by `.gitignore`.
- **Private subnets** — EC2 and RDS are deployed in private subnets with no public IPs.
- **No SSH** — EC2 access is via AWS Systems Manager Session Manager only.
- **Security groups by tier** — ALB, EC2, and RDS have separate security groups with minimal cross-tier access.
- **S3 state encryption** — Terraform state bucket uses server-side encryption and blocks public access.
- **DynamoDB locking** — Prevents concurrent state modifications.
- **IAM instance profiles** — EC2 uses IAM roles, not hardcoded credentials.
- **Least privilege** — IAM policies are scoped to required services only.

## Planned Security Improvements

- Use GitHub OIDC instead of long-lived AWS access keys for GitHub Actions.
- Add AWS Config rules for compliance checking.
- Enable CloudTrail for API audit logging.
- Add VPC Flow Logs.
- Enable GuardDuty for threat detection.
