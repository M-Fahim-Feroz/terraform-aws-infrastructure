Write-Host "Running Terraform Preflight Checks..."
terraform fmt -check -recursive
Push-Location environments/dev
terraform init -backend=false
terraform validate
Pop-Location

