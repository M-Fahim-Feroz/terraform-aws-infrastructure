# Continuous Integration & Deployment (CI/CD)

The GitHub Actions pipeline automates Terraform execution to guarantee code quality and security.

## Terraform Plan (Pull Requests)
When a Pull Request is opened:
1. **Checkout:** Pulls the repository.
2. **Setup Terraform:** Installs the HashiCorp CLI.
3. **Terraform Fmt:** Checks that code adheres to standard formatting.
4. **Terraform Validate:** Validates syntax and references.
5. **Checkov Security Scan:** Scans the `.tf` files for security best practices and compliance misconfigurations.
6. **Terraform Plan:** Generates a speculative execution plan and comments it on the PR.

## Terraform Apply (Main Branch)
When code is merged to `main`:
1. **Protected Trigger:** Requires manual approval (in enterprise scenarios) to prevent unintended infrastructure changes.
2. **Checkout & Setup:** Initializes the environment.
3. **Terraform Apply:** Runs `terraform apply -auto-approve` against the live AWS environment.

> Note: Workflows are currently placeholder scaffolding and will be activated once environments are implemented.
