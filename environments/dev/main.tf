# -----------------------------------------------------------------------------
# Module: VPC
# -----------------------------------------------------------------------------
module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones

  common_tags = var.common_tags
}

# -----------------------------------------------------------------------------
# Module: IAM
# -----------------------------------------------------------------------------
module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
}

# -----------------------------------------------------------------------------
# Module: ALB
# -----------------------------------------------------------------------------
module "alb" {
  source = "../../modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  common_tags = var.common_tags
}

# -----------------------------------------------------------------------------
# Module: EC2
# -----------------------------------------------------------------------------
module "ec2" {
  source = "../../modules/ec2"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  private_subnet_id     = module.vpc.private_subnet_ids[0]
  alb_security_group_id = module.alb.alb_security_group_id
  target_group_arn      = module.alb.target_group_arn
  instance_profile_name = module.iam.ec2_instance_profile_name
  instance_type         = var.instance_type

  common_tags = var.common_tags
}

# -----------------------------------------------------------------------------
# Module: RDS
# -----------------------------------------------------------------------------
module "rds" {
  source = "../../modules/rds"

  project_name               = var.project_name
  environment                = var.environment
  vpc_id                     = module.vpc.vpc_id
  private_subnet_ids         = module.vpc.private_subnet_ids
  ec2_security_group_id      = module.ec2.ec2_security_group_id
  db_name                    = var.db_name
  db_username                = var.db_username
  db_password                = var.db_password
  db_instance_class          = var.db_instance_class
  db_allocated_storage       = var.db_allocated_storage
  db_engine_version          = var.db_engine_version
  db_backup_retention_period = var.db_backup_retention_period
  db_multi_az                = var.db_multi_az
  db_deletion_protection     = var.db_deletion_protection
  db_skip_final_snapshot     = var.db_skip_final_snapshot

  common_tags = var.common_tags
}
