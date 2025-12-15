# VPC with NAT Gateway Example

Production-ready VPC with highly available NAT Gateways across 3 availability zones.

## Features

- ✅ 3 Availability Zones (HA)
- ✅ Public, Private, and Database subnets
- ✅ NAT Gateway per AZ (High Availability)
- ✅ Database subnet group
- ✅ Internet Gateway
- ✅ Short-format AZ specification

## Architecture

```
┌────────────────────────────────────────────────────────────────────────┐
│ VPC: 10.1.0.0/16                                                       │
│                                                                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐               │
│  │ AZ-a         │  │ AZ-b         │  │ AZ-c         │               │
│  │              │  │              │  │              │               │
│  │ Pub: .1.0/24 │  │ Pub: .2.0/24 │  │ Pub: .3.0/24 │               │
│  │ Pvt: .11.0/24│  │ Pvt: .12.0/24│  │ Pvt: .13.0/24│               │
│  │ DB:  .21.0/24│  │ DB:  .22.0/24│  │ DB:  .23.0/24│               │
│  │              │  │              │  │              │               │
│  │  ┌────────┐  │  │  ┌────────┐  │  │  ┌────────┐  │               │
│  │  │ NAT GW │  │  │  │ NAT GW │  │  │  │ NAT GW │  │               │
│  │  └────┬───┘  │  │  └────┬───┘  │  │  └────┬───┘  │               │
│  └───────┼──────┘  └───────┼──────┘  └───────┼──────┘               │
│          │                  │                  │                       │
│          └──────────────────┼──────────────────┘                       │
│                             │                                          │
│                   ┌─────────▼────────┐                                 │
│                   │ Internet Gateway │                                 │
│                   └──────────────────┘                                 │
└────────────────────────────────────────────────────────────────────────┘
```

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Costs

**Estimated monthly cost: ~$96/month**
- NAT Gateway: 3 × $32/month = $96/month
- Data processing: $0.045/GB

## Use Cases

- **Production applications** requiring HA
- **Microservices architectures**
- **Workloads requiring outbound internet** from private subnets
- **Database workloads** (RDS, Aurora)

## NAT Gateway Strategies

This example uses `one_nat_gateway_per_az = true` for high availability.

Alternative strategies:

### Single NAT Gateway (SPOF, $32/month)
```hcl
enable_nat_gateway = true
single_nat_gateway = true
```

### Per-Subnet NAT (varies by subnet count)
```hcl
enable_nat_gateway = true
# Creates one NAT per private subnet
```

## Database Subnet Group

Automatically creates an RDS subnet group for use with RDS/Aurora:

```hcl
resource "aws_db_instance" "example" {
  db_subnet_group_name = module.vpc.database_subnet_group_name
  # ...
}
```
