# VPC Terraform Module

## Overview
This module provisions a highly available Amazon Virtual Private Cloud (VPC) adhering to AWS best practices. It creates a robust networking foundation separating public internet-facing resources from secure internal resources.

## What This Module Creates
- **VPC:** The core networking boundary with a configurable CIDR.
- **Public Subnets:** Subnets spanning specified AZs, routing outbound traffic through an Internet Gateway.
- **Private Subnets:** Subnets spanning specified AZs, routing outbound traffic through a NAT Gateway.
- **Internet Gateway (IGW):** Allows communication between the VPC and the internet.
- **NAT Gateway & Elastic IP:** Allows private instances to access the internet for updates/API calls securely.
- **Route Tables:** Associated correctly to public and private subnets.

## Cost Warning
> ⚠️ **NAT Gateway Pricing:** AWS charges an hourly rate for NAT Gateways (~$32/month) plus data processing fees. By default, this module provisions **one single NAT Gateway** in the first public subnet to minimize costs for `dev` and portfolio environments. For high availability in production, you should eventually deploy a NAT Gateway in each AZ.

## Security Notes
- Resources in the private subnets have absolutely no inbound internet connectivity.
- DNS hostnames and support are enabled automatically.
- All deployed resources are tagged consistently for tracking and auditing.

## Future Improvements
- **Multi-AZ NAT Gateways:** Add a boolean variable (e.g., `multi_az_nat_gateway_enabled`) to deploy one NAT Gateway per public subnet for strict production redundancy.

## Example Usage
```hcl
module "vpc" {
  source = "../../modules/vpc"

  project_name         = "my-project"
  environment          = "dev"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
  
  common_tags = {
    Owner     = "DevOps"
    ManagedBy = "Terraform"
  }
}
```
