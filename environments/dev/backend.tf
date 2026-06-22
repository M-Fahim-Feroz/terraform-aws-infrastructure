terraform {
  backend "s3" {
    bucket         = "mfahim-terraform-aws-infra-state-2026"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-aws-infrastructure-locks"
    encrypt        = true
  }
}