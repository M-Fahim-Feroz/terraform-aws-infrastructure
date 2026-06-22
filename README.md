# Modular AWS Infrastructure Provisioning with Terraform

## 1. Project Overview
This repository is a comprehensive portfolio project demonstrating DevOps-focused AWS infrastructure provisioning. It implements modular, reusable Terraform code to deploy a highly available, secure cloud architecture, adhering to enterprise best practices.

## 2. Architecture Goal
The target architecture provisions a highly available environment across multiple availability zones:
- **VPC & Networking:** Public and Private Subnets, IGW, NAT Gateways.
- **Compute:** Scalable EC2 workloads without SSH, managed via SSM.
- **Database:** Secure, multi-AZ RDS PostgreSQL with strict micro-segmentation.
- **Load Balancing:** Application Load Balancer (ALB) for resilient traffic routing.
- **State Management:** S3 Remote Backend and DynamoDB state locking.
- **Security & IAM:** Least-privilege IAM roles and strict Security Groups.
- **Monitoring:** Centralized CloudWatch logging.

## 3. Tech Stack
- **Infrastructure as Code:** Terraform
- **Cloud Provider:** Amazon Web Services (AWS)
- **CI/CD:** GitHub Actions (Placeholder for Plan & Apply workflows)
- **Security Scanning:** Checkov

## 4. Current Status
- ✅ **Phase 1: Bootstrap layer implemented** (Secure S3 backend + DynamoDB locking)
- ✅ **Phase 2: VPC module implemented** (Highly available networking foundation)
- ✅ **Phase 3: IAM, ALB, and private EC2 implemented** (Zero-SSH web server architecture)
- ✅ **Phase 4: Private RDS PostgreSQL module implemented** (Fully secure, private database tier)
- ⏳ *Phase 5: Pending (CloudWatch module)*

## 5. Repository Structure
- `bootstrap/`: Secures Terraform state remotely with S3 and DynamoDB.
- `environments/`: Logical separations for infrastructure lifecycle (dev, prod).
- `modules/`: Standardized, reusable components (VPC, ALB, EC2, IAM, RDS, etc.).
- `docs/`: Expanded project documentation covering setup, architecture, and security.
- `.github/workflows/`: CI/CD definitions for automation.

## 6. Bootstrap & Deployment Instructions
Detailed, step-by-step instructions for bringing up this infrastructure are located in [`docs/setup.md`](docs/setup.md).

## 7. Best Practices Followed
- **Modular Design:** Infrastructure split into discrete, manageable components.
- **State Isolation:** Distinct state files for different environments.
- **State Protection:** `prevent_destroy` hooks, S3 versioning, and state locking enabled.
- **Variable Validation:** Strict inputs to prevent configuration drift or empty strings.
- **Documentation:** Robust guidelines to ensure codebase scalability.

## 8. Security Notes
- Secrets and credentials are never hardcoded or committed to git.
- S3 public access is globally blocked, and data is encrypted at rest (AES256).
- **Zero-SSH:** EC2 instances are entirely private, rely on ALB for inbound traffic, and utilize AWS Systems Manager for secure shell access.
- **Private Data:** RDS databases reside in private subnets, enforce storage encryption, and accept traffic strictly from the EC2 instance tier.

## 9. Deployment Proof Checklist
When presenting this portfolio project, ensure screenshots of the following successful deployments are captured:
- [ ] `terraform apply` output for the bootstrap layer
- [ ] S3 state bucket successfully created in the AWS Console
- [ ] DynamoDB lock table successfully created in the AWS Console
- [ ] `terraform apply` output for the dev environment
- [ ] VPC architecture in the AWS Console
- [ ] Application Load Balancer active in the AWS Console
- [ ] ALB Target Group showing healthy instances
- [ ] EC2 instance running in private subnet (No public IP)
- [ ] RDS PostgreSQL database running privately
- [ ] Web browser successfully displaying the simple web page via the ALB DNS name

## 10. CI/CD Plan
Future deployments will be managed entirely through GitHub Actions:
- **PR Creation:** Triggers `terraform fmt`, `terraform validate`, `terraform plan`, and Checkov security scanning.
- **Merge to Main:** Requires manual approval to trigger `terraform apply`.

## 11. Cleanup Warning
> **Warning:** AWS resources (NAT Gateway, ALB, EC2, RDS) cost money hourly. **Destroy the dev environment after testing to avoid charges.** See [`docs/cleanup.md`](docs/cleanup.md) for strict instructions on how to destroy your development environments safely and avoid unnecessary AWS billing.

## 12. Future Roadmap
- Phase 5: Configure CloudWatch.
- Phase 6: Fully activate GitHub Actions CI/CD.
