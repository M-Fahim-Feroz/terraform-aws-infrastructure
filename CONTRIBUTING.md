# Contributing

This is a personal portfolio project. Contributions welcome.

## Prerequisites

- Terraform v1.6+
- AWS CLI configured
- `terraform fmt` compliance

## Guidelines

- Run `terraform fmt -recursive` before committing.
- Run `terraform validate` in the modified environment.
- Do not commit `*.tfstate`, `*.tfvars`, or `.terraform/`.
- Document new modules in `docs/`.
- Add a cost note for any new resources that incur AWS charges.

## Pull Request Checklist

- [ ] `terraform fmt -check -recursive` passes
- [ ] `terraform validate` passes
- [ ] No `*.tfstate` or credentials committed
- [ ] README updated if new resources are added
- [ ] Cost implications documented
