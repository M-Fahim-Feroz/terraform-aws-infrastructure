# Security Architecture

## Network Security

### Private Subnets
All compute (EC2) and data (RDS) resources are deployed in private subnets. They have no public IP addresses and cannot be reached directly from the internet.

### Public Subnets
Only the Application Load Balancer (ALB) and NAT Gateway are in public subnets. The ALB receives public traffic and forwards to private EC2 instances.

### NAT Gateway
The NAT Gateway allows private EC2 instances to make outbound internet connections (e.g., for package updates) without being accessible inbound from the internet.

## Compute Security

### No SSH
EC2 instances do not use SSH keys and do not have port 22 open in security groups. Administrative access uses **AWS Systems Manager Session Manager**, which requires no open inbound ports.

### IAM Instance Profile
EC2 instances have an IAM role attached via an instance profile. This provides least-privilege access to AWS services (e.g., SSM) without hardcoded credentials.

### Private Subnets for EC2
Instances are not directly internet-accessible. All traffic flows through the ALB.

## Database Security

### Private Subnet Placement
RDS PostgreSQL is placed in private subnets with no public accessibility.

### Security Group Restriction
RDS accepts inbound traffic only from the EC2/application security group on port 5432. No other sources are permitted.

## Security Groups by Tier

| Security Group | Inbound | Outbound |
|---|---|---|
| ALB SG | 0.0.0.0/0 on port 80/443 | EC2 SG on app port |
| EC2 SG | ALB SG on app port, SSM endpoints | RDS SG on 5432, 0.0.0.0/0 for egress |
| RDS SG | EC2 SG on port 5432 | Minimal |

## State Security

- **S3 bucket encryption:** Server-side encryption enabled on the Terraform state bucket.
- **Public access blocked:** S3 public access block is set on the state bucket.
- **S3 versioning:** State modifications require acquiring a DynamoDB lock.
- **State not committed:** `*.tfstate` is excluded by `.gitignore`.

See [backend.md](backend.md) for full state backend details.

## Secrets and Credentials

- No AWS credentials are hardcoded in Terraform code.
- No `terraform.tfvars` with real values is committed.
- GitHub Actions uses `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` secrets.

## Planned Improvements

- Migrate GitHub Actions AWS authentication to OIDC federated credentials to eliminate long-lived access keys.
- Add AWS Config rules for continuous compliance.
- Enable CloudTrail for API audit logging.
- Add VPC Flow Logs for network monitoring.
- Enable GuardDuty for threat detection.
