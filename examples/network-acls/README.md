# Network ACLs Example

VPC with custom Network ACLs for enhanced security.

## Features
- Dedicated NACLs for public, private, and database subnets
- Granular port-level access control
- Defense in depth (NACLs + Security Groups)

## Security Layers
1. **Public NACL**: Allow HTTP/HTTPS inbound
2. **Private NACL**: Allow VPC traffic only
3. **Database NACL**: Allow PostgreSQL from private subnets only

## Cost: ~$96/month

## Use Cases
- Compliance requirements (PCI-DSS, HIPAA)
- Defense in depth security
- Regulatory environments
- Multi-tenant isolation
