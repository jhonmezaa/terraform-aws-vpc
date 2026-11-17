# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.2.0] - 2026-11-17

### Added

- `manage_default_security_group` (default `false`) with `default_security_group_name`, `default_security_group_ingress`, `default_security_group_egress` and `default_security_group_tags`: optionally adopt the VPC default security group and remove all of its rules (CIS AWS Foundations 5.4), as in the upstream module
- `ipv6_cidr_block` support in all dedicated Network ACL rules and in `default_network_acl_ingress`/`default_network_acl_egress` (the default NACL also honours `icmp_type`/`icmp_code` now)
- Outputs (parity with `terraform-aws-modules/vpc/aws`): `vpc_instance_tenancy`, `vpc_ipv6_association_id`, `vpc_secondary_cidr_blocks`, `default_security_group_id`, `default_route_table_id`, `egress_only_internet_gateway_id`, `natgw_interface_ids`, `outpost_subnets_cidr_blocks`, `vpc_flow_log_destination_arn`, `vpc_flow_log_destination_type` and `<type>_subnets_ipv6_cidr_blocks` for public, private, database, elasticache, redshift and intra subnets
- Region prefixes for `eu-central-2`, `eu-south-2`, `ap-south-2`, `ap-southeast-3`, `ap-southeast-4`, `ca-west-1`, `me-central-1` and `il-central-1` (previously resolved to `unknown`)
- Validation of `account_name` and `project_name` (1-32 characters, `^[a-z0-9-]+$`)

### Changed

- `tags_common` is no longer deprecated and is now applied to every resource (it was declared but ignored). It is merged before `tags`, which still wins on key conflicts
- `Name` and `ManagedBy = "Terraform"` are now merged last on every resource, so they can no longer be overridden by `tags` or per-resource tag maps
- `vpc_endpoint_tags` is now applied to the S3 and DynamoDB endpoints (it was declared but ignored)
- `flow_log_cloudwatch_iam_role_name` is now used for the flow log IAM role name (it was declared but ignored)
- The flow log IAM role policy is scoped to the flow log's log group (`<arn>:*` for `CreateLogStream`/`PutLogEvents`, `<arn>` for `Describe*`) instead of `"*"`, and no longer grants `logs:CreateLogGroup` (the module creates the group or you provide it), as in the upstream module
- `flow_log_cloudwatch_log_group_name_prefix` is marked as deprecated in its description (it has never been used)
- Clarify that `create_<database|elasticache|redshift>_internet_gateway_route` creates a route to the NAT Gateway
- README: module `source` uses `github.com/jhonmezaa/terraform-aws-vpc//vpc?ref=<tag>`, AWS provider badge `>= 6.0`, correct file names, naming/tagging conventions and new inputs/outputs

### Fixed

- `use_region_prefix = false` was ignored by subnets, route tables, NAT Gateways, EIPs, subnet groups, Network ACLs, VPC endpoints and the flow log IAM role, which always kept the region prefix
- Providing `flow_log_cloudwatch_log_group_name` without `flow_log_cloudwatch_log_group_arn` failed with `Invalid index`; the ARN is now built from the current partition, region and account
- `create_vpc = false` failed with `Invalid index` when `secondary_cidr_blocks` or `vpn_gateway_id` (with `enable_vpn_gateway`) were set; VPN route propagation to the public route table no longer fails when there are no public subnets
- With 11 or more subnets (or NAT Gateways) per tier, NAT Gateway placement, NAT routes and list outputs followed lexical key order (`"10"` before `"2"`); they now follow the input order

### Upgrade notes

- Only if you set `use_region_prefix = false`: the generated names of the resources listed above lose the region prefix. Tag-only changes are applied in place, but the database/elasticache/redshift subnet groups and the flow log IAM role are replaced because their `name` changes. Set `database_subnet_group_name`, `elasticache_subnet_group_name`, `redshift_subnet_group_name` and `flow_log_cloudwatch_iam_role_name` to the previous names to keep them
- If you set a `Name` key in `tags` or in a per-resource tag map (for example `vpc_tags`), it is now ignored: use `vpc_name`, `igw_name`, `<type>_subnet_names`, `default_network_acl_name` or the `*_subnet_group_name` variables instead
- If you passed `tags_common`, those tags are now added to every resource (in-place tag update)
- `account_name`/`project_name` values with uppercase letters, underscores or more than 32 characters are now rejected at plan time
- With the default `use_region_prefix = true` and 10 or fewer subnets per tier there are no changes to existing resources

## [v1.1.3] - 2026-10-27

### Changed

- Docs: normalize CHANGELOG format: move the Keep a Changelog preamble below the title, use `## [vX.Y.Z] - YYYY-MM-DD` headings for all entries and update the link references accordingly

## [v1.1.2] - 2026-10-27

### Fixed

- Replace deprecated `data.aws_region.current.id` with `data.aws_region.current.region` (AWS provider v6) in `vpc/9-locals.tf` and `vpc/10-vpc-endpoints.tf`

### Changed

- Stop tracking `.terraform.lock.hcl` and add it to `.gitignore`

## [v1.1.1] - 2026-10-27

### Changed

- Use minimum-only version constraints in the module (`vpc/`): AWS provider `~> 6.0` -> `>= 6.0`, so callers are not blocked from newer major provider versions
- Set module `required_version` to `>= 1.3` (was `~> 1.0`): the minimum real Terraform version, since variables use `optional()` object attributes (Terraform 1.3+)
- Examples (root modules) keep pessimistic constraints: `required_version` `~> 1.3`, AWS provider `~> 6.0`
- Update README requirements table and Terraform badge

## [v1.1.0] - 2026-02-28

### Added

- `use_region_prefix` boolean variable (default: `true`) to control whether the region prefix is included in resource names. When `false`, names omit the prefix

### Changed

- `name_prefix` local now resolves to the region prefix with a trailing dash (or an empty string when `use_region_prefix = false`) and is used to build the VPC, Internet Gateway, Egress-only Internet Gateway, VPN Gateway, DHCP Options and default Network ACL names
- Update README and reformat CHANGELOG

## [v1.0.4] - 2026-02-27

### Changed

- Standardize Terraform `required_version` to `~> 1.0` across module and examples

## [v1.0.3] - 2026-02-27

### Changed

- Update AWS provider constraint to `~> 6.0` across module and examples

## [v1.0.2] - 2026-01-21

### Fixed

#### Technical Improvements

- **AWS Region Data Source**: Changed from `data.aws_region.current.name` to `data.aws_region.current.id` for better reliability
  - Updated `vpc/9-locals.tf`: 3 occurrences (region_prefix lookup, AZ expansion, common_tags)
  - Updated `vpc/10-vpc-endpoints.tf`: 2 occurrences (S3 and DynamoDB service names)
  - **Rationale**: The `id` attribute is more reliable and consistent than `name`
  - **Impact**: No functional change, better compatibility with AWS provider best practices

### Changed

#### Version Constraints

- **Terraform version**: Changed from `~> 1.0` to `>= 1.0` for greater flexibility
- **AWS Provider version**: Changed from `~> 5.0` to `>= 5.0` for greater flexibility
- **Rationale**: Allows users to use newer versions of Terraform and AWS provider without module updates
- **Impact**: Better forward compatibility, no breaking changes

---

## [v1.0.1] - 2024-12-15

### Fixed

#### Documentation

- Fixed markdown code block formatting in README.md
- Corrected escaped backticks to proper code fences
- Added language specifiers (hcl, text) to code blocks
- Updated author information from placeholder to actual GitHub username
- Updated repository URLs from placeholder to jhonmezaa/terraform-aws-vpc
- Improved NAT Gateway Strategies section formatting
- Enhanced Best Practices section with emojis and better structure

## [v1.0.0] - 2024-12-14

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

[v1.2.0]: https://github.com/jhonmezaa/terraform-aws-vpc/releases/tag/v1.2.0
[v1.1.3]: https://github.com/jhonmezaa/terraform-aws-vpc/releases/tag/v1.1.3
[v1.1.2]: https://github.com/jhonmezaa/terraform-aws-vpc/releases/tag/v1.1.2
[v1.1.1]: https://github.com/jhonmezaa/terraform-aws-vpc/releases/tag/v1.1.1
[v1.1.0]: https://github.com/jhonmezaa/terraform-aws-vpc/releases/tag/v1.1.0
[v1.0.4]: https://github.com/jhonmezaa/terraform-aws-vpc/releases/tag/v1.0.4
[v1.0.3]: https://github.com/jhonmezaa/terraform-aws-vpc/releases/tag/v1.0.3
[v1.0.2]: https://github.com/jhonmezaa/terraform-aws-vpc/releases/tag/v1.0.2
[v1.0.1]: https://github.com/jhonmezaa/terraform-aws-vpc/releases/tag/v1.0.1
[v1.0.0]: https://github.com/jhonmezaa/terraform-aws-vpc/releases/tag/v1.0.0
