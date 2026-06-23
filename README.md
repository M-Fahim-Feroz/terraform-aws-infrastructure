# AWS Infrastructure Provisioning with Terraform

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

## Current Status

| Phase   | Status    | Description                                                                   |
| ------- | --------- | ----------------------------------------------------------------------------- |
| Phase 1 | Completed | Bootstrap layer with S3 remote backend and DynamoDB state locking             |
| Phase 2 | Completed | VPC module with public and private subnets across multiple Availability Zones |
| Phase 3 | Completed | IAM, ALB, and private EC2 instances using a zero-SSH access model             |
| Phase 4 | Completed | Private RDS PostgreSQL module with restricted security group access           |
| Phase 5 | Planned   | CloudWatch monitoring, alarms, and logging foundation                         |
| Phase 6 | Planned   | GitHub Actions CI/CD for Terraform automation                                 |

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

### Phase 6: GitHub Actions CI/CD

Planned CI/CD work includes:

* Terraform formatting check
* Terraform initialization
* Terraform validation
* Terraform plan on pull requests
* Checkov security scanning
* Manual approval before Terraform apply
* AWS OIDC authentication instead of long-lived IAM access keys

## Known Limitations

* CloudWatch monitoring is not implemented yet.
* GitHub Actions CI/CD is not active yet.
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
