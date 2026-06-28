# AWS Infrastructure Provisioning with Terraform

[![Terraform Plan](https://github.com/M-Fahim-Feroz/terraform-aws-infrastructure/actions/workflows/terraform-plan.yml/badge.svg)](https://github.com/M-Fahim-Feroz/terraform-aws-infrastructure/actions/workflows/terraform-plan.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazonaws&logoColor=white)](https://aws.amazon.com)
[![Terraform](https://img.shields.io/badge/Terraform-1.x-7B42BC?logo=terraform&logoColor=white)](https://terraform.io)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI%2FCD-2671E5?logo=githubactions&logoColor=white)](https://github.com/features/actions)

This repository contains Terraform code for provisioning a modular AWS infrastructure environment.

The project focuses on core DevOps infrastructure concepts such as remote state management, reusable Terraform modules, private networking, load balancing, IAM roles, and private database provisioning.

The infrastructure was deployed and tested on AWS, then destroyed after validation to avoid ongoing charges.

## Architecture Overview

The infrastructure follows a standard web application layout across multiple Availability Zones.

* VPC with public and private subnets
* Internet Gateway for public subnet access
* NAT Gateway for outbound access from private subnets
* Application Load Balancer for public HTTP traffic
* EC2 instances deployed in private subnets
* RDS PostgreSQL deployed in private subnets
* S3 remote backend for Terraform state
* DynamoDB table for Terraform state locking

> See the [full architecture diagram](docs/architecture.md) with Mermaid flowcharts.

## Project Highlights

- **Fully modular Terraform** — each infrastructure layer (VPC, EC2, ALB, IAM, RDS) is an independent, reusable module with clear input/output contracts
- **Zero-SSH architecture** — EC2 instances run in private subnets with no public IP or SSH access; all management goes through AWS Systems Manager
- **Remote state with locking** — Terraform state is stored in S3 with DynamoDB state locking, preventing concurrent applies and state corruption
- **Protected manual apply** — `terraform apply` requires explicit `workflow_dispatch` with a confirmation input (`APPLY`), preventing accidental infrastructure changes
- **Multi-AZ high availability** — VPC spans multiple Availability Zones with public/private subnet pairs and a NAT Gateway for secure outbound traffic
- **Private database tier** — RDS PostgreSQL runs in private subnets with no direct internet access, accessed only from EC2 instances via security groups

## Current Status

| Phase   | Status    | Description                                                                   |
| ------- | --------- | ----------------------------------------------------------------------------- |
| Phase 1 | Completed | Bootstrap layer with S3 remote backend and DynamoDB state locking             |
| Phase 2 | Completed | VPC module with public and private subnets across multiple Availability Zones |
| Phase 3 | Completed | IAM, ALB, and private EC2 instances using a zero-SSH access model             |
| Phase 4 | Completed | Private RDS PostgreSQL module with restricted security group access           |
| Phase 5 | Planned   | CloudWatch monitoring, alarms, and logging foundation                         |
| Phase 6 | Completed | GitHub Actions CI/CD for Terraform automation                                 |

## What This Project Deploys

* VPC
* Public and private subnets
* Route tables
* Internet Gateway
* NAT Gateway
* Application Load Balancer
* Target group
* Private EC2 instances
* IAM roles and instance profile
* RDS PostgreSQL
* Security groups
* S3 backend bucket
* DynamoDB lock table

## Prerequisites

* Terraform v1.0+
* AWS CLI configured with appropriate permissions
* AWS account with permissions to create VPC, EC2, ALB, RDS, IAM, S3, and DynamoDB resources

## Repository Structure

```text
.
├── bootstrap/
├── environments/
│   └── dev/
├── modules/
│   ├── alb/
│   ├── ec2/
│   ├── iam/
│   ├── rds/
│   └── vpc/
├── docs/
│   └── screenshots/
└── .github/
    └── workflows/
```

* `bootstrap/` contains the S3 bucket and DynamoDB table used for Terraform remote state.
* `environments/dev/` contains the development environment configuration.
* `modules/` contains reusable Terraform modules.
* `docs/` contains supporting documentation and screenshots.
* `.github/workflows/` is reserved for planned CI/CD workflows.

## Terraform State Management

Terraform state is stored remotely in an S3 bucket instead of being kept only on the local machine.

The backend layer includes:

* S3 bucket for remote state
* DynamoDB table for state locking
* S3 bucket versioning
* S3 server-side encryption
* Public access blocking
* Protection settings for critical backend resources

This helps keep state safer and prevents multiple Terraform operations from modifying the same state file at the same time.

## Networking Design

The VPC is split across multiple Availability Zones.

Public subnets are used for internet-facing resources such as the Application Load Balancer and NAT Gateway.

Private subnets are used for EC2 instances and the RDS database. This keeps compute and database resources away from direct public internet access.

## Compute Layer

EC2 instances are deployed in private subnets.

The instances do not use SSH keys and do not have public IP addresses. Administrative access is intended through AWS Systems Manager Session Manager.

This keeps the compute layer private while still allowing controlled access when needed.

## Database Layer

The RDS PostgreSQL database is deployed in private subnets.

Database access is restricted using security groups. The database only accepts traffic from the application/EC2 tier and is not publicly accessible.

## Load Balancing Layer

The Application Load Balancer is deployed in public subnets.

It receives HTTP traffic and forwards it to the private EC2 instances through a target group. This allows the application layer to stay private while still being reachable through the ALB.

## IAM and Access Model

IAM roles and instance profiles are used for EC2 access to AWS services.

The project avoids hardcoded AWS credentials inside Terraform code or instance configuration. EC2 access is designed around AWS Systems Manager instead of SSH.

## Security Notes

* No secrets or credentials are committed to the repository.
* Terraform state is stored in an encrypted S3 bucket.
* Public access to the state bucket is blocked.
* DynamoDB is used for Terraform state locking.
* EC2 instances are placed in private subnets.
* SSH access is not used.
* RDS PostgreSQL is placed in private subnets.
* RDS access is restricted to the EC2/application security group.
* Security groups are separated by infrastructure tier.

## Usage

### 1. Bootstrap the Backend

First, create the S3 bucket and DynamoDB table used for Terraform state.

```bash
cd bootstrap
terraform init
terraform apply
```

### 2. Deploy the Development Environment

After the backend is created, deploy the main infrastructure.

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

### 3. Destroy the Infrastructure

To avoid ongoing AWS charges, destroy the environment after testing.

```bash
cd environments/dev
terraform destroy
```

## Validation

The deployment was validated by checking the following:

* Terraform output
* ALB browser response
* EC2 instance running state
* EC2 status checks
* Target group health checks
* RDS availability
* VPC resource map
* S3 backend bucket
* DynamoDB lock table

## Reference Screenshots

Screenshots are included to show the infrastructure after deployment and before cleanup.

### Application Load Balancer

![ALB Browser Page](docs/screenshots/01-alb-browser-page.png)

### EC2 Instance and Status Checks

![EC2 Instance Running](docs/screenshots/02-ec2-instance-running.png)

![EC2 Status Checks](docs/screenshots/03-ec2-status-checks.png)

### Load Balancer Target Group

![Load Balancer Active](docs/screenshots/04-load-balancer-active.png)

![Target Group Healthy](docs/screenshots/05-target-group-healthy.png)

### RDS PostgreSQL

![RDS Available](docs/screenshots/06-rds-available.png)

### VPC Topology

![VPC Resource Map](docs/screenshots/07-vpc-resource-map.png)

### State Backend

![S3 State Bucket](docs/screenshots/09-s3-state-bucket.png)

![DynamoDB Lock Table](docs/screenshots/10-dynamodb-lock-table.png)

## Cleanup and Cost Control

The AWS resources shown in the screenshots were created for testing and validation.

After testing, the resources were destroyed using `terraform destroy` to avoid ongoing AWS charges. The infrastructure is not currently running, but it can be recreated from the Terraform code.

## Planned Work

### Phase 5: CloudWatch Monitoring

Planned monitoring work includes:

* CloudWatch Log Group
* EC2 CPU utilization alarm
* RDS free storage alarm
* SNS topic for alert notifications
* Optional email subscription
* Possible CloudWatch Agent setup for EC2 logs

### Future Security Improvements

**1. GitHub OIDC Migration**
To further enhance supply chain security, the CI/CD pipeline should be migrated from static, long-lived AWS IAM Access Keys to GitHub Actions OIDC (OpenID Connect). This would involve:
- Creating a GitHub Actions OIDC provider in AWS.
- Provisioning an IAM role with least privilege bound to this repository.
- Using `aws-actions/configure-aws-credentials` with `role-to-assume`.
- Removing all long-lived AWS access keys from GitHub Secrets.

**2. GitHub Environments & Required Reviewers**
The manual apply workflow uses the `terraform-apply` environment. In a production setup, this GitHub Environment should have "Required reviewers" enabled in the repository settings to enforce human approval before Terraform apply runs.

## Release & Changelog
### Suggested First Release
- **v1.0.0**: Initial portfolio-ready release.
  - Includes full CI/CD pipeline, security cleanup, and structured deployment documentation.
- See `CHANGELOG.md` for a complete history of updates.
- It is highly recommended to leverage [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases) to bundle version tags cleanly.

## Known Limitations

* CloudWatch monitoring is not implemented yet.
* The infrastructure is not currently running.
* The EC2 layer uses a simple web server setup for validation rather than a full application.
* The current environment is focused on `dev`; a separate `prod` environment can be added later.

## Lessons Learned

This project helped reinforce several Terraform and AWS infrastructure concepts:

* Structuring Terraform code into reusable modules
* Managing Terraform state with S3 and DynamoDB
* Designing a multi-AZ VPC layout
* Keeping EC2 and RDS resources private
* Using security groups to separate infrastructure tiers
* Using IAM roles and instance profiles instead of hardcoded credentials
* Cleaning up AWS resources after testing to control cost

---

## Suggested Release

- **Suggested first release:** 1.0.0
- **Title:** Initial Production Release
- **Release notes:**
  - Implemented full CI/CD pipeline automation
  - Added security scanning and linting gates
  - Containerized components with multi-stage Docker builds
  - Established Infrastructure-as-Code definitions
  - Configured remote state management and backend tracking
