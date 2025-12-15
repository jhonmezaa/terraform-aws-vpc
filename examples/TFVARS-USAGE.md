# Using terraform.tfvars Files

Each example includes a `terraform.tfvars.example` file demonstrating recommended values.

## Quick Start

1. **Copy the example file:**
   ```bash
   cd examples/<example-name>
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Customize your values:**
   ```bash
   # Edit with your preferred editor
   vim terraform.tfvars
   # or
   nano terraform.tfvars
   # or
   code terraform.tfvars
   ```

3. **Deploy:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Security Notes

- ⚠️ **Never commit `terraform.tfvars` files** - they may contain sensitive data
- ✅ The `.gitignore` file automatically excludes `*.tfvars` files
- ✅ Only `*.tfvars.example` files are committed to version control
- ✅ Example files contain no sensitive information

## Example Structure

Each `terraform.tfvars.example` file includes:

- **Commented defaults** - Values that match the example's main.tf
- **Customization examples** - Common overrides you might need
- **Helpful comments** - Guidance on what each value does
- **Best practices** - Recommended configurations

## Common Patterns

### Development Environment
```hcl
# terraform.tfvars
account_name = "dev"
project_name = "myapp"

tags = {
  Environment = "development"
  Team        = "platform"
}
```

### Staging Environment
```hcl
# terraform.tfvars
account_name = "staging"
project_name = "myapp"

enable_nat_gateway     = true
one_nat_gateway_per_az = true

tags = {
  Environment = "staging"
  Team        = "platform"
}
```

### Production Environment
```hcl
# terraform.tfvars
account_name = "prod"
project_name = "myapp"

enable_nat_gateway     = true
one_nat_gateway_per_az = true

enable_flow_log                                 = true
flow_log_cloudwatch_log_group_retention_in_days = 30

tags = {
  Environment = "production"
  Team        = "platform"
  Compliance  = "required"
  Backup      = "daily"
}
```

## Multiple Environments

You can maintain multiple tfvars files for different environments:

```bash
# Create environment-specific files
terraform.tfvars.dev
terraform.tfvars.staging
terraform.tfvars.prod

# Use specific file when running Terraform
terraform plan -var-file="terraform.tfvars.dev"
terraform apply -var-file="terraform.tfvars.prod"
```

## Workspace Pattern

Alternatively, use Terraform workspaces:

```bash
# Create workspaces
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# Switch workspace
terraform workspace select prod

# Use workspace in tfvars
# terraform.tfvars
account_name = terraform.workspace
project_name = "myapp"
```

## Variable Precedence

Terraform loads variables in this order (later overrides earlier):

1. Environment variables (`TF_VAR_name`)
2. `terraform.tfvars` file
3. `terraform.tfvars.json` file
4. `*.auto.tfvars` or `*.auto.tfvars.json` files
5. `-var` and `-var-file` command line flags

## Best Practices

### ✅ Do:
- Copy `.example` files to create your own
- Use descriptive values for `account_name` and `project_name`
- Add environment-specific tags
- Document custom values with comments
- Use version control for `.example` files

### ❌ Don't:
- Commit `terraform.tfvars` to git
- Store secrets or credentials in tfvars
- Share tfvars files between projects without review
- Hardcode sensitive values

## Secrets Management

For sensitive values, use:

1. **AWS Secrets Manager:**
   ```hcl
   data "aws_secretsmanager_secret_version" "db_password" {
     secret_id = "prod/db/password"
   }
   ```

2. **Environment Variables:**
   ```bash
   export TF_VAR_db_password="secret"
   terraform apply
   ```

3. **External Secret Stores:**
   - HashiCorp Vault
   - AWS Parameter Store
   - Azure Key Vault
   - Google Secret Manager

## Troubleshooting

**Problem:** Variables not being loaded

```bash
# Solution: Verify file name
ls -la terraform.tfvars

# Solution: Check for syntax errors
terraform validate

# Solution: Use explicit var-file
terraform plan -var-file="terraform.tfvars"
```

**Problem:** Sensitive data in tfvars

```bash
# Solution: Use sensitive variable marking
variable "db_password" {
  type      = string
  sensitive = true
}

# Solution: Use data sources instead
data "aws_secretsmanager_secret_version" "password" {
  secret_id = var.secret_id
}
```

## Additional Resources

- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)
- [Variable Definition Precedence](https://www.terraform.io/docs/language/values/variables.html#variable-definition-precedence)
- [Sensitive Data in State](https://www.terraform.io/docs/language/state/sensitive-data.html)
