# VPC Module Examples

This directory contains comprehensive examples demonstrating all features and use cases of the VPC module.

## 📁 Examples Overview

| Example | Use Case | Cost/Month | Key Features |
|---------|----------|------------|--------------|
| [minimal](./minimal/) | Absolute minimum configuration | $0 | Auto-detected AZs, no NAT |
| [basic-vpc](./basic-vpc/) | Development environment | $0 | 2 AZs, public/private subnets, no NAT |
| [vpc-with-nat-gateway](./vpc-with-nat-gateway/) | Production standard | ~$96 | 3 AZs, HA NAT Gateway, DB subnets |
| [complete-vpc](./complete-vpc/) | Production enterprise | ~$100 | 6 subnet types, Flow Logs, VPC Endpoints |
| [ipv6-vpc](./ipv6-vpc/) | IPv6 dual-stack | ~$96 | Full IPv6 support, egress-only IGW |
| [vpn-gateway](./vpn-gateway/) | Hybrid connectivity | ~$132 | VPN Gateway, route propagation |
| [network-acls](./network-acls/) | Enhanced security | ~$96 | Custom NACLs per subnet type |
| [secondary-cidrs](./secondary-cidrs/) | IP expansion | ~$96 | Additional CIDR blocks |
| [outposts](./outposts/) | AWS Outposts | Varies | Outpost subnet integration |

## 🚀 Quick Start

Each example includes:
- `main.tf` - Module configuration
- `variables.tf` - Input variables
- `outputs.tf` - Output values
- `README.md` - Specific documentation
- `versions.tf` - Provider requirements

### Usage

```bash
# Navigate to any example
cd examples/basic-vpc

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply

# Clean up
terraform destroy
```

## 📊 Feature Matrix

| Feature | Minimal | Basic | NAT GW | Complete | IPv6 | VPN | NACLs | Secondary | Outposts |
|---------|---------|-------|--------|----------|------|-----|-------|-----------|----------|
| **Public Subnets** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Private Subnets** | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Database Subnets** | ❌ | ❌ | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | ❌ |
| **Elasticache Subnets** | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| **Redshift Subnets** | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| **Intra Subnets** | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| **Outpost Subnets** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Internet Gateway** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **NAT Gateway** | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **NAT HA (per AZ)** | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **IPv6** | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Egress-only IGW** | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **VPN Gateway** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| **Custom NACLs** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| **Flow Logs** | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| **VPC Endpoints** | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| **DHCP Options** | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Secondary CIDRs** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| **Multi-AZ** | Auto | 2 | 3 | 3 | 3 | 3 | 3 | 3 | 1 |

## 🎯 Choosing the Right Example

### Development & Testing
- **minimal** - Just getting started, want simplest possible VPC
- **basic-vpc** - Need private subnets but no outbound internet from them

### Production - Standard
- **vpc-with-nat-gateway** - Most common production setup
- **complete-vpc** - Enterprise with multiple service types

### Specialized Use Cases
- **ipv6-vpc** - IPv6 requirements or dual-stack networking
- **vpn-gateway** - Hybrid cloud, on-premises connectivity
- **network-acls** - Enhanced security, compliance requirements
- **secondary-cidrs** - Running out of IPs, need to expand VPC
- **outposts** - AWS Outposts integration

## 💡 Common Patterns

### AZ Specification (Short Format)
All examples use the short AZ format:
```hcl
azs = ["a", "b", "c"]  # Auto-detects region
```

### Cost Optimization
- Development: Use `basic-vpc` (no NAT Gateway)
- Production: Use `single_nat_gateway = true` for cost savings (SPOF)
- Production HA: Use `one_nat_gateway_per_az = true` (recommended)

### Naming Convention
All resources follow the pattern:
```
{region_prefix}-{resource-type}-{account_name}-{project_name}[-{az}]
```

## 📚 Additional Resources

- [Module Documentation](../README.md)
- [Variables Reference](../vpc/7-variables.tf)
- [Outputs Reference](../vpc/6-outputs.tf)
- [AWS VPC Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)

## 🔒 Security Notes

- Never commit `*.tfvars` files with real credentials
- Use AWS Secrets Manager for sensitive data
- Enable VPC Flow Logs for production environments
- Use private subnets for application workloads
- Restrict public subnets to load balancers and NAT Gateways

## 🆘 Troubleshooting

### Common Issues

**"Quota exceeded for NAT Gateways"**
- Check AWS service quotas in your region
- Request quota increase if needed

**"CIDR block overlaps"**
- Ensure VPC CIDR doesn't overlap with existing VPCs
- Check for conflicts with on-premises networks

**"Cannot delete VPC - has dependencies"**
- Ensure all resources in VPC are deleted first
- Check for ENIs, security groups, route tables still in use

## 📝 Contributing

When adding new examples:
1. Follow the existing directory structure
2. Include all standard files (main.tf, variables.tf, outputs.tf, README.md, versions.tf)
3. Document the specific use case
4. Update this main README with the new example
5. Test with `terraform plan` and `terraform apply`

## Using terraform.tfvars Files

Each example includes a `terraform.tfvars.example` file with recommended values.

### Quick Setup

```bash
# Navigate to example
cd examples/basic-vpc

# Copy example file
cp terraform.tfvars.example terraform.tfvars

# Customize values
vim terraform.tfvars

# Deploy
terraform init
terraform plan
terraform apply
```

### Security

- ⚠️ **Never commit `terraform.tfvars`** - may contain sensitive data
- ✅ Files matching `*.tfvars` are automatically git-ignored
- ✅ Only `*.tfvars.example` files are version controlled

See [TFVARS-USAGE.md](./TFVARS-USAGE.md) for detailed instructions.
