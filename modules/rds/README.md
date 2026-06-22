# RDS Module
Provisions a private, secure RDS PostgreSQL database.

## Features:
- **Private Subnet Only:** The database is not accessible from the public internet. `publicly_accessible` is set to false.
- **EC2-Only Ingress:** The Security Group restricts inbound port 5432 traffic strictly to the EC2 security group.
- **Storage Encryption:** Enforced storage encryption for data at rest.
- **Sensitive Variables:** The master database password is treated as a sensitive variable and is NOT output to the console.

## Configuration Warnings
- **`deletion_protection`**: For dev, this defaults to `false` for easy teardown. For production, this MUST be `true` to prevent accidental database deletion.
- **`skip_final_snapshot`**: For dev, this defaults to `true` to allow rapid tearing down without cluttering snapshot storage. For production, this MUST be `false` to ensure data isn't permanently lost upon deletion.
