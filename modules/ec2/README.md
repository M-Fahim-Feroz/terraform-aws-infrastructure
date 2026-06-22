# EC2 Module
Provisions a private compute instance serving a basic web page. 
Features:
- **Private Subnet:** No public IP assignment.
- **ALB-Only Ingress:** Security group strictly denies all traffic except port 80 from the ALB.
- **Session Manager Access:** Relies entirely on SSM IAM roles for secure shell access without opening port 22 or provisioning PEM keys.
