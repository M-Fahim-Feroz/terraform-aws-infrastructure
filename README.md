# Modular AWS Infrastructure Provisioning with Terraform

## Project Overview
This repository contains a portfolio project focused on provisioning AWS infrastructure using Terraform. The goal is to build a modular setup that deploys core networking, compute, and database components using infrastructure as code.

## Architecture Summary
The architecture is designed to span multiple availability zones for high availability. Traffic enters through an Application Load Balancer in public subnets and is routed to EC2 instances in private subnets. The EC2 instances connect to a private RDS PostgreSQL database. All outbound internet access from the private subnets is routed through NAT Gateways. 

## Current Implementation Status
Phase 1: Completed — Bootstrap layer with S3 remote backend and DynamoDB state locking
Phase 2: Completed — VPC module with public and private subnets across multiple Availability Zones
Phase 3: Completed — IAM, ALB, and private EC2 instances using a zero-SSH access model
Phase 4: Completed — Private RDS PostgreSQL module with restricted security group access
Phase 5: Planned — CloudWatch monitoring, alarms, and logging foundation
Phase 6: Planned — GitHub Actions CI/CD for Terraform automation

## AWS Services Used
- VPC (Virtual Private Cloud)
- Public and Private Subnets
- Internet Gateway (IGW)
- NAT Gateway
- Application Load Balancer (ALB)
- EC2 (Elastic Compute Cloud)
- IAM (Identity and Access Management)
- RDS PostgreSQL
- S3 (Simple Storage Service)
- DynamoDB

## Repository Structure
- `bootstrap/`: Terraform code to create the S3 bucket and DynamoDB table for remote state management.
- `environments/`: Contains environment-specific configurations (e.g., dev, prod) that call the modules.
- `modules/`: Reusable Terraform modules for VPC, ALB, EC2, IAM, and RDS components.
- `docs/`: Additional documentation on setup, architecture, and security.
- `.github/workflows/`: Placeholders for future CI/CD pipeline definitions.

## Terraform Workflow
The infrastructure was deployed and tested using the standard Terraform command line workflow:
- `terraform init` to initialize the working directory.
- `terraform plan` to review proposed infrastructure changes.
- `terraform apply` to provision the resources in AWS.
- `terraform destroy` to tear down the environment.

## Security Notes
- AWS credentials and secrets are not hardcoded or committed to version control.
- S3 bucket public access is blocked, and encryption is enabled.
- EC2 instances are placed in private subnets and do not use SSH keys. Access is managed through AWS Systems Manager (SSM).
- The RDS database is placed in private subnets and restricted by security groups to only allow traffic from the EC2 instances.

## Deployment Proof / Screenshots
The infrastructure was successfully deployed to AWS and verified.

Application Load Balancer Entrypoint:
![ALB Browser Page](docs/screenshots/01-alb-browser-page.png)

EC2 Compute Layer:
![EC2 Instance Running](docs/screenshots/02-ec2-instance-running.png)
![EC2 Status Checks](docs/screenshots/03-ec2-status-checks.png)

Load Balancing Health:
![Load Balancer Active](docs/screenshots/04-load-balancer-active.png)
![Target Group Healthy](docs/screenshots/05-target-group-healthy.png)

Database Layer:
![RDS Available](docs/screenshots/06-rds-available.png)

Network Topology:
![VPC Resource Map](docs/screenshots/07-vpc-resource-map.png)

Terraform Execution:
![Terraform Output](docs/screenshots/08-terraform-output.png)

State Management:
![S3 State Bucket](docs/screenshots/09-s3-state-bucket.png)
![DynamoDB Lock Table](docs/screenshots/10-dynamodb-lock-table.png)

## Cleanup Note
All AWS resources shown in the screenshots above (including the NAT Gateway, ALB, EC2 instance, and RDS database) were destroyed immediately after testing using `terraform destroy`. The environment is not currently running to avoid ongoing AWS charges.

## Planned Phase 5: CloudWatch Monitoring
Future work for monitoring may include:
- CloudWatch Log Group
- EC2 CPU utilization alarm
- RDS free storage alarm
- SNS topic for alert notifications
- Optional email subscription
- Possible CloudWatch Agent setup for EC2 logs

## Planned Phase 6: GitHub Actions CI/CD
Future work for automation may include:
- `terraform fmt`
- `terraform init`
- `terraform validate`
- `terraform plan`
- Checkov security scan
- Manual approval before `terraform apply`
- AWS OIDC authentication instead of long-lived IAM access keys

## Future Improvements
- Refactoring modules to support more dynamic scaling.
- Containerizing workloads with ECS or EKS.

## What I Learned
- Managing Terraform state securely with S3 and DynamoDB.
- Designing a standard VPC topology from scratch.
- Using IAM Instance Profiles to avoid managing long-lived SSH keys.
- Applying security groups to restrict traffic strictly between the ALB, EC2, and RDS layers.
