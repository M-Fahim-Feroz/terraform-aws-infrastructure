variable "aws_region" {
  description = "The AWS region to deploy the bootstrap infrastructure"
  type        = string
  default     = "us-east-1"
  validation {
    condition     = length(var.aws_region) > 0
    error_message = "The aws_region variable must not be empty."
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "terraform-aws-infra"
  validation {
    condition     = length(var.project_name) > 0
    error_message = "The project_name variable must not be empty."
  }
}

variable "environment" {
  description = "Environment name for bootstrap (e.g., dev, staging, prod, or bootstrap)"
  type        = string
  default     = "bootstrap"
  validation {
    condition     = contains(["dev", "staging", "prod", "bootstrap"], var.environment)
    error_message = "The environment variable must be one of: dev, staging, prod, or bootstrap."
  }
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state (must be globally unique)"
  type        = string
  validation {
    condition     = length(var.state_bucket_name) > 0
    error_message = "The state_bucket_name variable must not be empty."
  }
}

variable "lock_table_name" {
  description = "Name of the DynamoDB table for Terraform state locking"
  type        = string
  default     = "terraform-state-lock"
  validation {
    condition     = length(var.lock_table_name) > 0
    error_message = "The lock_table_name variable must not be empty."
  }
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "terraform-aws-infra"
    Environment = "bootstrap"
    ManagedBy   = "Terraform"
  }
}
