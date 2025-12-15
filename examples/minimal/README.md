# Minimal VPC Example

This example demonstrates the absolute minimum configuration needed to create a VPC using this module.

## Features

- ✅ Minimal configuration (only required variables)
- ✅ Auto-detected availability zones
- ✅ Public subnets only
- ✅ Internet Gateway
- ❌ No NAT Gateway (cost: $0/month)
- ❌ No private subnets

## Architecture

```
┌─────────────────────────────────────────┐
│ VPC: 10.0.0.0/16                        │
│                                         │
│  ┌──────────────┐  ┌──────────────┐   │
│  │ AZ-a         │  │ AZ-b         │   │
│  │              │  │              │   │
│  │ Public       │  │ Public       │   │
│  │ 10.0.1.0/24  │  │ 10.0.2.0/24  │   │
│  │              │  │              │   │
│  └──────┬───────┘  └──────┬───────┘   │
│         │                  │           │
│         └─────────┬────────┘           │
│                   │                    │
│         ┌─────────▼────────┐           │
│         │ Internet Gateway │           │
│         └──────────────────┘           │
└─────────────────────────────────────────┘
```

## Usage

```bash
# Initialize
terraform init

# Plan
terraform plan

# Apply
terraform apply

# Destroy
terraform destroy
```

## Costs

**Estimated monthly cost: $0**
- VPC: Free
- Subnets: Free
- Internet Gateway: Free
- NAT Gateway: Not used
- Data transfer: Pay per GB (not included)

## Use Cases

- Quick testing
- Learning Terraform
- Proof of concept
- Simple web applications (static sites, CDN origins)
- Resources that only need inbound internet access

## Limitations

- No private subnets (all resources are publicly accessible)
- No NAT Gateway (cannot make outbound internet connections from private resources)
- Not suitable for production workloads requiring private networking
