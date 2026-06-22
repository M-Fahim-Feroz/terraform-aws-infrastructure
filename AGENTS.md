# AI Agent Coding Guidelines

When assisting with this Terraform repository, please strictly adhere to the following rules:

1. **Implement one phase at a time:** Do not rush into building modules or environments the user hasn't asked for.
2. **Never hardcode secrets:** Do not place AWS access keys, secret keys, passwords, or account IDs directly in the code.
3. **Never create `terraform.tfvars`:** Use `terraform.tfvars.example` only, to avoid accidentally committing secrets.
4. **Preserve `.terraform.lock.hcl`:** This lock file is critical for tracking provider versions and must not be ignored or deleted.
5. **Run `terraform fmt`:** Always format the code after making modifications.
6. **Run `terraform validate`:** Where possible, validate the configuration.
7. **Update documentation:** Always update READMEs and docs after infrastructure changes (e.g. outputs, architecture, or variables changes).
8. **Avoid overengineering:** Keep Terraform beginner-readable but production-inspired. Don't build unnecessary abstractions.
9. **Do not destroy or weaken state backend protections:** Never remove `prevent_destroy` or public access blocks from the state bucket or DynamoDB table.
