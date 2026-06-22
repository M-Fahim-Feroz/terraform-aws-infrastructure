# IAM Module
Creates IAM Roles and Instance Profiles required for the infrastructure. Currently provisions an EC2 role with `AmazonSSMManagedInstanceCore` to securely allow access via AWS Systems Manager Session Manager, completely eliminating the need for SSH keys.
