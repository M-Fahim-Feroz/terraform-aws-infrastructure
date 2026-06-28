# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - Initial Release
### Added
- Comprehensive multi-AZ AWS infrastructure deployment via Terraform.
- Modularized architecture for VPC, EC2, ALB, IAM, and RDS components.
- Remote state management using S3 backend and DynamoDB state locking.
- GitHub Actions workflows for continuous integration and manual apply.
- Zero-SSH model relying on AWS Systems Manager.
