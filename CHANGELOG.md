# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2024-12-15

### Fixed

#### Documentation
- Fixed markdown code block formatting in README.md
- Corrected escaped backticks to proper code fences
- Added language specifiers (hcl, text) to code blocks
- Updated author information from placeholder to actual GitHub username
- Updated repository URLs from placeholder to jhonmezaa/terraform-aws-vpc
- Improved NAT Gateway Strategies section formatting
- Enhanced Best Practices section with emojis and better structure

## [1.0.0] - 2024-12-14

### 🎉 Initial Release

First production-ready release of the AWS VPC Terraform module with comprehensive networking features.

### Added

#### Core VPC Features
- VPC creation with customizable CIDR blocks
- Support for 7 subnet types: Public, Private, Database, Elasticache, Redshift, Intra, Outpost
- Multi-AZ deployment support (1-16 availability zones)
- IPv4 and IPv6 dual-stack networking
- Secondary CIDR block support for VPC expansion
- Automatic region prefix generation for resource naming
- Consistent resource naming convention across all resources

#### Subnet Management
- Public subnets with Internet Gateway access
- Private subnets with NAT Gateway support
- Database subnets with automatic subnet group creation
- Elasticache subnets with automatic subnet group creation
- Redshift subnets with automatic subnet group creation
- Intra subnets (no internet access)
- Outpost subnets for AWS Outposts integration
- Per-subnet custom naming support
- Per-subnet custom tagging support
- IPv6 support for all subnet types

#### NAT Gateway Strategies
- No NAT Gateway (cost optimization)
- Single NAT Gateway (SPOF, lowest cost)
- One NAT Gateway per Availability Zone (HA)
- One NAT Gateway per private subnet
- Support for reusing existing Elastic IPs
- Automatic Elastic IP creation and management

#### Internet Connectivity
- Internet Gateway creation and management
- Egress-only Internet Gateway for IPv6
- VPN Gateway for hybrid cloud connectivity
- VPN Gateway route propagation to route tables
- Custom BGP ASN support for VPN Gateway

#### VPC Endpoints
- S3 Gateway Endpoint support
- DynamoDB Gateway Endpoint support
- Custom VPC Endpoint configuration
- Automatic route table association

#### Network Security
- Custom Network ACL support for all subnet types
- Dedicated Network ACL per subnet type
- Inbound and outbound NACL rules
- Default Network ACL management
- Security group ready architecture

#### VPC Flow Logs
- CloudWatch Logs destination support
- S3 destination support
- Kinesis Firehose destination support
- Custom log format support
- Automatic IAM role creation for CloudWatch
- Configurable retention periods
- Traffic type filtering (ALL, ACCEPT, REJECT)
- File format options (plain-text, parquet)

#### Route Management
- Automatic route table creation per AZ
- Public route table (single for all public subnets)
- Private route tables (per AZ or per subnet)
- Database route tables (optional, per AZ)
- Elasticache route tables (optional, per AZ)
- Redshift route tables (optional, per AZ)
- Intra route tables (per AZ, no internet routes)
- VPN Gateway route propagation
- Separate route resources for better management

#### DHCP Options
- Custom DNS servers configuration
- Custom domain name configuration
- NTP servers configuration
- NetBIOS name servers configuration
- NetBIOS node type configuration

#### Availability Zone Features
- Short-format AZ specification (`azs = ["a", "b", "c"]`)
- Full-format AZ support (`azs = ["us-east-1a", ...]`)
- Auto-detection of available AZs
- Maximum AZ limit configuration
- Region-portable configurations

#### Tagging
- Global tags applied to all resources
- Resource-specific tag support for:
  - VPC
  - Subnets (all types)
  - Route tables (all types)
  - Internet Gateway
  - NAT Gateways
  - VPN Gateway
  - DHCP Options
  - Network ACLs
  - Flow Logs
- Kubernetes integration tags support
- Automatic `Name` tag generation
- Common tags (ManagedBy, Project, Account, Region)

#### Outputs
- VPC outputs (ID, CIDR, ARN, IPv6 CIDR)
- All subnet IDs by type
- Route table IDs
- NAT Gateway IDs and public IPs
- Internet Gateway ID
- VPN Gateway ID and ARN
- Egress-only Internet Gateway ID
- Subnet group names (Database, Elasticache, Redshift)
- VPC Endpoint IDs
- Flow Log IDs
- Network ACL IDs
- Availability zones used
- 100+ total outputs

#### Examples
- **minimal**: Absolute minimum configuration ($0/month)
- **basic-vpc**: Development environment with public/private subnets ($0/month)
- **vpc-with-nat-gateway**: Production with HA NAT Gateway (~$96/month)
- **complete-vpc**: Enterprise with all 6 subnet types (~$100/month)
- **ipv6-vpc**: IPv6 dual-stack networking (~$96/month)
- **vpn-gateway**: Hybrid cloud connectivity (~$132/month)
- **network-acls**: Custom Network ACLs for enhanced security (~$96/month)
- **secondary-cidrs**: VPC expansion with secondary CIDRs (~$96/month)
- **outposts**: AWS Outposts integration (varies)
- Example validation script (`validate-all.sh`)

#### Documentation
- Comprehensive README with usage examples
- Feature comparison matrix
- Cost estimation for all examples
- Best practices guide
- Troubleshooting section
- Module structure documentation
- Individual README for each example
- Input and output variable documentation
- Architecture diagrams

#### Code Quality
- Terraform 1.0+ compatibility
- AWS Provider 5.0+ compatibility
- Numbered file organization (0-14)
- Consistent code formatting
- Comprehensive variable validation
- Terraform validate passing for all examples
- For-each pattern throughout (no count)
- Dynamic blocks for optional features

### Technical Details

#### Supported Regions
- All AWS commercial regions
- Automatic region prefix mapping for 20+ regions
- Custom region prefix override support

#### Resource Limits
- Up to 16 availability zones
- Up to 5 secondary CIDR blocks
- Unlimited subnets per type (AWS limits apply)
- Up to 100 Network ACL rules per subnet type

#### Performance
- Efficient use of for_each over count
- Minimal resource dependencies
- Optimized data source queries
- Lazy evaluation of optional resources

#### Compatibility
- Terraform >= 1.0
- AWS Provider >= 5.0
- Compatible with Terraform Cloud
- Compatible with Terragrunt
- Module composition ready

### Fixed

#### Flow Logs
- Fixed `destination_options` only appearing for S3 destinations
- Resolved CloudWatch Logs compatibility issue

#### Network ACLs
- Fixed NACL rule attribute names (`rule_number` vs `rule_no`)
- Corrected NACL rule action names (`rule_action` vs `action`)

#### VPN Gateway
- Fixed VPN Gateway ID reference in route propagation
- Corrected conditional logic for existing vs created VPN Gateway

#### Locals
- Fixed `region_prefix` null comparison (was `!= ""`, now `!= null`)
- Fixed subnet name list comparisons (was `!= []`, now `length() > 0`)

#### AZ Processing
- Implemented short-format AZ expansion logic
- Fixed region auto-detection for AZ names

### Dependencies

#### Required Providers
- hashicorp/aws >= 5.0

#### Terraform Version
- terraform >= 1.0

### Notes

- This is the first stable release (1.0.0)
- All features are production-ready
- Breaking changes will follow semantic versioning
- See examples for recommended usage patterns
- Cost estimates based on us-east-1 pricing as of Dec 2024

### Migration Notes

This is the first release - no migration needed.

### Known Issues

None reported in this release.

### Contributors

- Initial implementation and release

---

## Release Checklist

- [x] All examples validated with `terraform validate`
- [x] README.md documentation complete
- [x] CHANGELOG.md created
- [x] All input variables documented
- [x] All outputs documented
- [x] Code formatted with `terraform fmt`
- [x] Examples cover all major use cases
- [x] Naming conventions consistent
- [x] Security best practices implemented
- [x] Cost optimization patterns documented

[1.0.1]: https://github.com/jhonmezaa/terraform-aws-vpc/releases/tag/v1.0.1
[1.0.0]: https://github.com/jhonmezaa/terraform-aws-vpc/releases/tag/v1.0.0
