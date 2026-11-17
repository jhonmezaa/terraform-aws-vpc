# AWS VPC Terraform Module

Production-ready Terraform module for creating AWS Virtual Private Clouds (VPCs) with comprehensive networking features.

[![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.3-blue.svg)](https://www.terraform.io/downloads.html)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-%3E%3D6.0-orange.svg)](https://registry.terraform.io/providers/hashicorp/aws/latest)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Features

### 🌐 Network Architecture

- **7 Subnet Types**: Public, Private, Database, Elasticache, Redshift, Intra, Outpost
- **Multi-AZ Support**: High availability across availability zones
- **IPv4 & IPv6**: Full dual-stack networking support
- **Secondary CIDRs**: VPC expansion without downtime
- **NAT Strategies**: No NAT, Single NAT, Per-AZ NAT, Per-Subnet NAT

### 🔒 Security

- **Network ACLs**: Custom rules per subnet type (IPv4 and IPv6)
- **VPC Flow Logs**: CloudWatch or S3 destinations
- **Default Security Group**: Optional lockdown of the VPC default security group (`manage_default_security_group`)
- **Private Subnets**: Isolated workload deployment

### 🔌 Connectivity

- **Internet Gateway**: Public internet access
- **NAT Gateway**: Outbound internet from private subnets
- **VPN Gateway**: Hybrid cloud connectivity
- **VPC Endpoints**: Private AWS service access (S3, DynamoDB)
- **Egress-only IGW**: IPv6 outbound-only access

### ⚙️ Advanced Features

- **DHCP Options**: Custom DNS, NTP, NetBIOS configuration
- **Route Propagation**: VPN Gateway route distribution
- **Subnet Groups**: RDS, Elasticache, Redshift ready
- **IPAM Integration**: Enterprise IP address management
- **AWS Outposts**: Edge computing support

### 🏷️ Management

- **Consistent Naming**: Auto-generated resource names
- **Flexible Tagging**: Resource-level tag customization
- **Short AZ Format**: Region-portable configuration (\`azs = ["a", "b", "c"]\`)
- **Comprehensive Outputs**: All resource IDs and attributes

## Quick Start

### Basic VPC

```hcl
module "vpc" {
  source = "github.com/jhonmezaa/terraform-aws-vpc//vpc?ref=v1.2.0"

  account_name = "dev"
  project_name = "myapp"

  azs = ["a", "b"]

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

  tags_common = {
    Environment = "dev"
  }
}
```

### Production VPC with HA NAT

```hcl
module "vpc" {
  source = "github.com/jhonmezaa/terraform-aws-vpc//vpc?ref=v1.2.0"

  account_name = "prod"
  project_name = "ecommerce"

  vpc_cidr_block = "10.0.0.0/16"
  azs            = ["a", "b", "c"]

  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

  create_database_subnet_group = true

  # NAT Gateway - One per AZ for HA
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true

  # VPC Flow Logs
  enable_flow_log                     = true
  flow_log_destination_type           = "cloud-watch-logs"
  create_flow_log_cloudwatch_iam_role = true

  # VPC Endpoints
  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  tags_common = {
    Environment = "production"
  }
}
```

## Examples

See the [examples](./examples/) directory for 9 complete examples:

| Example                                                  | Description           | Cost/Month |
| -------------------------------------------------------- | --------------------- | ---------- |
| [minimal](./examples/minimal/)                           | Minimum configuration | $0         |
| [basic-vpc](./examples/basic-vpc/)                       | Development           | $0         |
| [vpc-with-nat-gateway](./examples/vpc-with-nat-gateway/) | Production HA         | ~$96       |
| [complete-vpc](./examples/complete-vpc/)                 | Enterprise            | ~$100      |
| [ipv6-vpc](./examples/ipv6-vpc/)                         | IPv6 dual-stack       | ~$96       |
| [vpn-gateway](./examples/vpn-gateway/)                   | Hybrid connectivity   | ~$132      |
| [network-acls](./examples/network-acls/)                 | Enhanced security     | ~$96       |
| [secondary-cidrs](./examples/secondary-cidrs/)           | IP expansion          | ~$96       |
| [outposts](./examples/outposts/)                         | AWS Outposts          | Varies     |

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | >= 1.3  |
| aws       | >= 6.0  |

## Key Features

### Subnet Types

| Type        | Purpose         | Internet | Use Case          |
| ----------- | --------------- | -------- | ----------------- |
| Public      | Internet-facing | Yes      | Load balancers    |
| Private     | Apps            | Via NAT  | EC2, ECS, EKS     |
| Database    | RDS/Aurora      | No       | Databases         |
| Elasticache | Cache           | No       | Redis/Memcached   |
| Redshift    | Analytics       | No       | Data warehouse    |
| Intra       | Isolated        | No       | Internal services |
| Outpost     | Edge            | Varies   | AWS Outposts      |

### NAT Gateway Strategies

**No NAT ($0/month)**

```hcl
enable_nat_gateway = false
```

**Single NAT ($32/month - SPOF)**

```hcl
enable_nat_gateway = true
single_nat_gateway = true
```

**Per-AZ NAT ($96/month for 3 AZs - HA)**

```hcl
enable_nat_gateway     = true
one_nat_gateway_per_az = true
```

### Short AZ Format

**Short format (recommended)**

```hcl
azs = ["a", "b", "c"]  # Auto-detects region
```

**Full format (also supported)**

```hcl
azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
```

### Naming Convention

All resources follow: `{region_prefix}-{resource}-{account}-{project}[-{az}]`

The region prefix is derived from the current region (for example `us-east-1` => `ause1`) or set with `region_prefix`. Set `use_region_prefix = false` to omit it from every generated name (for example `vpc-prod-myapp`). `account_name` and `project_name` must be 1-32 characters of lowercase letters, numbers and hyphens.

**Examples:**

- VPC: `ause1-vpc-prod-myapp`
- Subnet: `ause1-subnet-public-prod-myapp-us-east-1a`
- NAT: `ause1-nat-prod-myapp-us-east-1a`

### Tagging

Every resource gets `merge(tags_common, tags, <resource tags>, { Name = <name>, ManagedBy = "Terraform" })`, plus the `Project`, `Account`, `Region` and `RegionCode` tags. `tags` is kept for backward compatibility and wins over `tags_common` on key conflicts.

## Core Inputs

| Name                   | Description           | Type         | Default       | Required |
| ---------------------- | --------------------- | ------------ | ------------- | -------- |
| account_name           | Account name (1-32, `^[a-z0-9-]+$`) | string | -    | yes      |
| project_name           | Project name (1-32, `^[a-z0-9-]+$`) | string | -    | yes      |
| region_prefix          | Region prefix override | string      | null          | no       |
| use_region_prefix      | Include region prefix in names | bool | true        | no       |
| tags_common            | Tags for all resources | map(string) | {}            | no       |
| tags                   | Tags for all resources (legacy) | map(string) | {}   | no       |
| vpc_cidr_block         | VPC CIDR              | string       | "10.0.0.0/16" | no       |
| azs                    | Availability zones    | list(string) | null          | no       |
| public_subnets         | Public subnet CIDRs   | list(string) | []            | no       |
| private_subnets        | Private subnet CIDRs  | list(string) | []            | no       |
| database_subnets       | Database subnet CIDRs | list(string) | []            | no       |
| enable_nat_gateway     | Create NAT Gateway    | bool         | false         | no       |
| one_nat_gateway_per_az | NAT per AZ            | bool         | false         | no       |
| map_public_ip_on_launch | Auto-assign public IPv4 in public subnets | bool | true | no |
| manage_default_security_group | Remove all rules from the default SG | bool | false | no |

See [variables.tf](./vpc/7-variables.tf) for complete list (120+ variables).

## Core Outputs

| Name                       | Description        |
| -------------------------- | ------------------ |
| vpc_id                     | VPC ID             |
| vpc_cidr_block             | VPC CIDR           |
| public_subnets             | Public subnet IDs  |
| private_subnets            | Private subnet IDs |
| database_subnet_group_name | RDS subnet group   |
| nat_ids                    | NAT Gateway IDs    |
| nat_public_ips             | NAT public IPs     |
| default_security_group_id  | Default SG ID      |
| vpc_secondary_cidr_blocks  | Secondary CIDRs    |

See [outputs.tf](./vpc/6-outputs.tf) for complete list (100+ outputs).

## Module Structure

```text
vpc/
├── 0-versions.tf           # Provider requirements
├── 1-vpc.tf                # VPC resource
├── 2-igw.tf                # Internet Gateway / Egress-only IGW
├── 3-subnets.tf            # All subnet types
├── 4-nat.tf                # NAT Gateways and EIPs
├── 5-routes.tf             # Route tables
├── 6-outputs.tf            # Module outputs
├── 7-variables.tf          # Input variables
├── 8-data.tf               # Data sources
├── 9-locals.tf             # Local values
├── 10-vpc-endpoints.tf     # VPC Endpoints
├── 11-flow-logs.tf         # VPC Flow Logs
├── 12-dhcp-options.tf      # DHCP Options
├── 13-nacls.tf             # Network ACLs and default security group
└── 14-vpn-gateway.tf       # VPN Gateway
```

## Best Practices

### Production Deployments

- ✅ **Use 3 AZs** for high availability
- ✅ **Enable NAT Gateway per AZ** to avoid SPOF
- ✅ **Enable VPC Flow Logs** for monitoring and compliance
- ✅ **Use private subnets** for application workloads
- ✅ **Enable VPC Endpoints** to reduce NAT Gateway costs

### Cost Optimization

- 💰 **Disable NAT** for dev/test environments ($0/month)
- 💰 **Use single NAT Gateway** for non-critical workloads ($32/month)
- 💰 **Implement VPC Endpoints** to avoid data transfer charges
- 💰 **Right-size subnet allocations** to minimize IP waste

### Security

- 🔒 **Never use public subnets** for databases or backend services
- 🔒 **Implement Network ACLs** for defense in depth
- 🔒 **Enable VPC Flow Logs** for security monitoring
- 🔒 **Use private subnets** for all workloads
- 🔒 **Apply least-privilege** security group policies

## License

MIT License - see [LICENSE](LICENSE)

## Author

Created and maintained by [Jhon Meza](https://github.com/jhonmezaa)

## Support

- Issues: [GitHub Issues](https://github.com/jhonmezaa/terraform-aws-vpc/issues)
- Documentation: [Examples](./examples/)
