# AWS Outposts Example

VPC configured for AWS Outposts integration.

## Features
- Support for Outpost subnets
- Hybrid cloud and edge computing
- Local subnets on Outpost hardware

## Requirements
- AWS Outposts hardware installed
- Outpost ARN from AWS Console

## Configuration
Uncomment and configure in main.tf:
```hcl
outpost_subnets = ["10.9.100.0/24"]
outpost_arn     = "arn:aws:outposts:..."
```

## Use Cases
- Edge computing
- Low-latency workloads
- Data residency requirements
- Hybrid cloud architectures
