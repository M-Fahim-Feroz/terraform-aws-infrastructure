# Cost Notes — Terraform AWS Infrastructure

> [!CAUTION]
> This project provisions real AWS resources. Always destroy after testing to avoid ongoing charges.

## Estimated Monthly Cost (us-east-1)

| Resource | Config | Estimated Cost |
|---|---|---|
| EC2 Instance | t3.micro (private subnet) | ~$8/month |
| RDS PostgreSQL | db.t3.micro, 20 GB | ~$15/month |
| Application Load Balancer | Standard | ~$20/month |
| NAT Gateway | 1× AZ | ~$32/month |
| S3 State Bucket | LRS, tiny file | <$1/month |
| DynamoDB Lock Table | On-demand | <$1/month |
| **Total (approximate)** | | **~$76–80/month** |

> **Note:** NAT Gateway is the biggest surprise cost. Consider removing it and using VPC endpoints if only SSM access is needed.

## Cost Reduction Tips

- **Destroy after demo** — entire stack can be reprovisioned in ~10 minutes.
- **Use t3.nano** instead of t3.micro to reduce EC2 cost slightly.
- **Use AWS Free Tier** — t3.micro and db.t3.micro are Free Tier eligible for 12 months.
- **Remove NAT Gateway** — if instances only need SSM (no outbound internet), replace NAT Gateway with a VPC endpoint for SSM.

## AWS Free Tier Eligibility

| Resource | Free Tier |
|---|---|
| EC2 t3.micro | 750 hours/month for 12 months |
| RDS db.t3.micro | 750 hours/month for 12 months |
| S3 | 5 GB storage |
| NAT Gateway | NOT free |
| ALB | 750 hours/month for 12 months |

## Destroy Everything

```bash
cd environments/dev
terraform destroy
# Confirm with: yes
```
