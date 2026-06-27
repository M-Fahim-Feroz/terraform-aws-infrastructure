# GitHub Issues Backlog

Prepared issues for the terraform-aws-infrastructure repository.
Create at: https://github.com/M-Fahim-Feroz/terraform-aws-infrastructure/issues/new

---

## Issue 1

**Title:** [CI] Replace placeholder workflows with real Terraform CI/CD
**Labels:** `ci`, `terraform`
**Priority:** High

**Description:**
Both `terraform-apply.yml` and `terraform-plan.yml` are placeholder files. Replace with real workflows: a CI validation workflow running fmt/validate/Checkov on PRs, and a manual-only apply workflow.

**Acceptance Criteria:**
- [ ] `terraform fmt -check -recursive` runs on PR
- [ ] `terraform validate` runs on PR
- [ ] Checkov security scan runs on PR
- [ ] Apply is manual-only via `workflow_dispatch`
- [ ] No placeholder `echo` steps remain

---

## Issue 2

**Title:** [Security] Add Checkov or tfsec scanning
**Labels:** `security`, `terraform`
**Priority:** High

**Description:**
Add static security analysis for Terraform code using Checkov or tfsec to catch common misconfigurations.

**Acceptance Criteria:**
- [ ] Checkov or tfsec runs in CI on every PR
- [ ] Known exceptions documented with suppression comments
- [ ] Scan results visible in PR checks

---

## Issue 3

**Title:** [Security] Document AWS OIDC setup for GitHub Actions
**Labels:** `security`
**Priority:** Medium

**Description:**
Currently using long-lived `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`. Document (and eventually implement) GitHub OIDC federation for keyless AWS authentication.

**Acceptance Criteria:**
- [ ] OIDC setup documented in `docs/security.md`
- [ ] IAM trust policy snippet provided
- [ ] Workflow snippet updated to use OIDC

---

## Issue 4

**Title:** [Monitoring] Add CloudWatch alarms module (Phase 5)
**Labels:** `enhancement`, `monitoring`
**Priority:** Medium

**Description:**
Phase 5 planned work: Add a CloudWatch module with EC2 CPU, RDS storage, ALB 5xx alarms and an SNS notification topic.

**Acceptance Criteria:**
- [ ] `modules/cloudwatch/` created
- [ ] EC2 CPU alarm configured
- [ ] RDS free storage alarm configured
- [ ] ALB 5xx alarm configured
- [ ] SNS topic created
- [ ] Module integrated in `environments/dev/main.tf`

---

## Issue 5

**Title:** [Cost] Add cost warning and AWS Budget recommendation
**Labels:** `documentation`
**Priority:** Low

**Description:**
Add a clear cost warning to README and AZURE_DEPLOYMENT.md listing which resources incur ongoing AWS charges and how to set up an AWS Budget alert.

**Acceptance Criteria:**
- [ ] NAT Gateway cost noted
- [ ] ALB cost noted
- [ ] RDS cost noted
- [ ] `terraform destroy` command prominently placed
- [ ] AWS Budgets setup link included

---

## Issue 6

**Title:** [Release] Create v1.0.0 infrastructure release
**Labels:** `release`
**Priority:** Low

**Description:**
Tag the repository at current stable state as v1.0.0 with a GitHub Release including screenshots and Terraform validation proof.

**Acceptance Criteria:**
- [ ] Git tag `v1.0.0` created
- [ ] GitHub Release with screenshots
- [ ] Release notes list all implemented phases
