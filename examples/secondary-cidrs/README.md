# Secondary CIDR Blocks Example

VPC with additional CIDR blocks for IP address expansion.

## Features
- Primary CIDR: 10.6.0.0/16
- Secondary CIDRs: 10.7.0.0/16, 10.8.0.0/16
- Expand VPC IP space without migration

## Cost: ~$96/month

## Use Cases
- Running out of IPs in primary CIDR
- Gradual expansion without downtime
- Large-scale deployments (EKS, ECS)
- Merging networks

## Limitations
- Maximum 5 CIDR blocks per VPC
- Cannot overlap with existing routes
- Secondary CIDRs must be from RFC1918 ranges
