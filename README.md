# AWS Infrastructure Provisioning with Terraform

This repository contains Terraform configurations to provision a secure, highly available AWS infrastructure environment.

## Architecture Overview

The infrastructure spans multiple Availability Zones and implements a standard web architecture:

* **Networking:** VPC, public subnets, private subnets, Internet Gateway, and NAT Gateways.
* **Compute:** EC2 instances in private subnets, accessed strictly via AWS Systems Manager (SSM).
* **Database:** Private RDS PostgreSQL instance restricted to compute tier traffic.
* **Load Balancing:** Application Load Balancer (ALB) routing HTTP traffic to the private EC2 instances.
* **State Management:** S3 remote backend with DynamoDB state locking.

## Prerequisites

* Terraform v1.0+
* AWS CLI configured with appropriate permissions

## Usage

1. **Bootstrap the Backend:**
   First, provision the S3 bucket and DynamoDB table for remote state locking.
   ```bash
   cd bootstrap
   terraform init
   terraform apply
   ```

2. **Deploy the Environment:**
   Once the backend exists, deploy the main infrastructure.
   ```bash
   cd environments/dev
   terraform init
   terraform plan
   terraform apply
   ```

3. **Cleanup:**
   To avoid ongoing AWS charges, destroy the infrastructure when finished.
   ```bash
   cd environments/dev
   terraform destroy
   ```

## Repository Structure

* `bootstrap/` - S3 and DynamoDB resources for Terraform state backend.
* `environments/dev/` - The development environment configuration invoking the modules.
* `modules/` - Reusable Terraform modules (`vpc`, `alb`, `ec2`, `iam`, `rds`).
* `docs/` - Extended architecture and setup documentation.

## Security Posture

* **Zero-SSH:** EC2 instances do not have SSH keys or public IPs. Access is provided securely via SSM Session Manager.
* **Network Isolation:** The database resides in private subnets with security groups restricting access only from the application tier.
* **State Encryption:** Terraform state is stored in S3 with encryption enabled and public access completely blocked.

## Reference Screenshots

Application Load Balancer:
![ALB Browser Page](docs/screenshots/01-alb-browser-page.png)

EC2 Instance & Status:
![EC2 Instance Running](docs/screenshots/02-ec2-instance-running.png)
![EC2 Status Checks](docs/screenshots/03-ec2-status-checks.png)

Load Balancer Target Group:
![Load Balancer Active](docs/screenshots/04-load-balancer-active.png)
![Target Group Healthy](docs/screenshots/05-target-group-healthy.png)

RDS PostgreSQL:
![RDS Available](docs/screenshots/06-rds-available.png)

VPC Topology:
![VPC Resource Map](docs/screenshots/07-vpc-resource-map.png)

State Backend:
![S3 State Bucket](docs/screenshots/09-s3-state-bucket.png)
![DynamoDB Lock Table](docs/screenshots/10-dynamodb-lock-table.png)

## Roadmap / TODOs

* [ ] **CloudWatch Monitoring:** Implement a logging foundation, EC2 CPU utilization alarms, RDS storage alarms, and an SNS notification topic.
* [ ] **GitHub Actions CI/CD:** Automate `terraform fmt`, `init`, `validate`, `plan`, and Checkov security scanning on Pull Requests, using AWS OIDC authentication.
