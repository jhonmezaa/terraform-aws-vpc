# VPN Gateway Example

VPC with VPN Gateway for hybrid cloud connectivity.

## Features
- VPN Gateway with BGP ASN
- Route propagation to private/database subnets
- Hybrid connectivity to on-premises networks

## Cost: ~$132/month
- VPN Gateway: ~$36/month
- NAT Gateways: ~$96/month

## Use Cases
- Hybrid cloud architectures
- On-premises to AWS connectivity
- Site-to-site VPN connections
- AWS Direct Connect backup

## Setup
After applying, create VPN connections:
```bash
aws ec2 create-vpn-connection \
  --type ipsec.1 \
  --customer-gateway-id cgw-xxx \
  --vpn-gateway-id vgw-xxx
```
