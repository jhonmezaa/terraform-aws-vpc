# Basic VPC Example

Standard development VPC with public and private subnets across 2 availability zones.

## Features

- ✅ Public and private subnets
- ✅ Internet Gateway
- ✅ 2 Availability Zones
- ✅ Short-format AZ specification
- ❌ No NAT Gateway (cost optimization)
- ❌ No database subnets

## Architecture

```
┌──────────────────────────────────────────────────────────────┐
│ VPC: 10.0.0.0/16                                             │
│                                                              │
│  ┌────────────────────────┐  ┌────────────────────────┐    │
│  │ AZ-a                   │  │ AZ-b                   │    │
│  │                        │  │                        │    │
│  │ Public: 10.0.1.0/24    │  │ Public: 10.0.2.0/24    │    │
│  │ Private: 10.0.11.0/24  │  │ Private: 10.0.12.0/24  │    │
│  │                        │  │                        │    │
│  └────────┬───────────────┘  └────────┬───────────────┘    │
│           │                           │                     │
│           └───────────┬───────────────┘                     │
│                       │                                     │
│             ┌─────────▼────────┐                            │
│             │ Internet Gateway │                            │
│             └──────────────────┘                            │
└──────────────────────────────────────────────────────────────┘
```

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Costs

**Estimated monthly cost: $0**
- NAT Gateway: Not used

## Use Cases

- Development environments
- Testing and staging (non-critical)
- Workloads that don't need outbound internet from private subnets
- Cost-conscious setups

## Limitations

- Private subnets cannot access the internet (no NAT Gateway)
- Not suitable for production workloads requiring outbound internet access
