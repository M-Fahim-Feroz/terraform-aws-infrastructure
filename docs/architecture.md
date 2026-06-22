# Architecture Overview

This project simulates a highly available enterprise-grade AWS deployment.

## Current Architecture (Phase 4: Database layer)
We have successfully deployed the networking foundation, computed resources securely behind a load balancer, and a fully isolated RDS database.

```text
       [Internet]
           |
           v
    [Internet Gateway]
           |
           v
---------------------------------------------------
|                   VPC                           |
|                                                 |
|   [Public Subnet 1]        [Public Subnet 2]    |
|      (ALB & NAT GW)                             |
|           |                                     |
|           |-----------------------------------| |
|           v                                   | |
|   [Private Subnet 1]       [Private Subnet 2] | |
|    (EC2 Web Server)                           | |
|           |                                   | |
|           |-----------------------------------| |
|           v                                   | |
|   [Private Subnet 1]       [Private Subnet 2] | |
|    (RDS PostgreSQL)        (RDS PostgreSQL)   | |
---------------------------------------------------
```

## Networking Layer (VPC)
- Designed with high availability across at least two Availability Zones (AZs).
- **Public Subnets:** Host the Application Load Balancer and NAT Gateways. Routes `0.0.0.0/0` to the Internet Gateway.
- **Private Subnets:** Host the internal Compute layer (EC2) and RDS Databases, shielding them from the open internet. Routes `0.0.0.0/0` to the NAT Gateway.

## Compute Layer (EC2)
- Deployed in the first private subnet.
- **Inbound Routing:** Strictly accepts traffic only from the Application Load Balancer (ALB).
- **Outbound Routing:** Internet access for patching/updates is routed securely through the NAT Gateway.
- **Access Management:** SSH (Port 22) is fully disabled. Administration is handled via AWS Systems Manager (SSM) Session Manager.

## Load Balancing Layer (ALB)
- Public-facing internet entrypoint.
- Terminates HTTP requests and forwards them to the private Target Group.

## Database Layer (RDS PostgreSQL)
- **Extreme Isolation:** The RDS instance is deployed inside the Private Subnets. It possesses no public IP, and it cannot be accessed directly from the internet.
- **Micro-segmentation:** The RDS Security Group strictly accepts inbound traffic on port `5432` only from the EC2 Security Group.

## State Management
- **S3 Bucket:** AES256 encrypted, versioned, public-access blocked.
- **DynamoDB:** Enables state locking via a `LockID` hash key to prevent race conditions during deployments.
