variable "project_name" {
  description = "Name of the project"
  type        = string
  validation {
    condition     = length(var.project_name) > 0
    error_message = "The project_name variable must not be empty."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment variable must be one of: dev, staging, prod."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the database"
  type        = list(string)
  validation {
    condition     = length(var.private_subnet_ids) > 0
    error_message = "At least one private subnet must be provided."
  }
}

variable "ec2_security_group_id" {
  description = "The ID of the EC2 security group allowed to access the database"
  type        = string
}

variable "db_name" {
  description = "Name of the initial database"
  type        = string
  validation {
    condition     = length(var.db_name) > 0
    error_message = "The db_name variable must not be empty."
  }
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  validation {
    condition     = length(var.db_username) > 0
    error_message = "The db_username variable must not be empty."
  }
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.db_password) > 0
    error_message = "The db_password variable must not be empty."
  }
}

variable "db_instance_class" {
  description = "The RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
  validation {
    condition     = var.db_allocated_storage >= 20
    error_message = "Allocated storage must be at least 20 GB."
  }
}

variable "db_engine_version" {
  description = "The PostgreSQL engine version"
  type        = string
  default     = "16"
}

variable "db_backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 1
  validation {
    condition     = var.db_backup_retention_period >= 0 && var.db_backup_retention_period <= 35
    error_message = "Backup retention period must be between 0 and 35."
  }
}

variable "db_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "db_deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "db_skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
