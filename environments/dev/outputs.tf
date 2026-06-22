output "vpc_id" {
  description = "The ID of the Dev VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the Dev public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "The IDs of the Dev private subnets"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_public_ip" {
  description = "The Public IP of the Dev NAT Gateway"
  value       = module.vpc.nat_gateway_public_ip
}

output "alb_dns_name" {
  description = "The public DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "ec2_instance_id" {
  description = "The ID of the private EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = module.ec2.instance_private_ip
}

output "db_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = module.rds.db_endpoint
}

output "db_port" {
  description = "The port the RDS instance is listening on"
  value       = module.rds.db_port
}

output "db_name" {
  description = "The database name"
  value       = module.rds.db_name
}
