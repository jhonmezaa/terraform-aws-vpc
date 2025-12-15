# =============================================================================
# VPC Core Variables
# =============================================================================

variable "create_vpc" {
  description = "Controls if VPC should be created (affects all resources)."
  type        = bool
  default     = true
}

variable "vpc_cidr_block" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr_block))
    error_message = "VPC CIDR block must be valid CIDR notation."
  }
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC."
  type        = string
  default     = "default"

  validation {
    condition     = contains(["default", "dedicated"], var.instance_tenancy)
    error_message = "Instance tenancy must be 'default' or 'dedicated'."
  }
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "enable_network_address_usage_metrics" {
  description = "Determines whether network address usage metrics are enabled for the VPC."
  type        = bool
  default     = false
}

# =============================================================================
# IPv6 Variables
# =============================================================================

variable "enable_ipv6" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC."
  type        = bool
  default     = false
}

variable "ipv6_cidr_block" {
  description = "IPv6 CIDR block to request from an IPAM Pool."
  type        = string
  default     = null
}

variable "ipv6_ipam_pool_id" {
  description = "IPAM Pool ID for IPv6 allocation."
  type        = string
  default     = null
}

variable "ipv6_netmask_length" {
  description = "Netmask length for IPv6 CIDR."
  type        = number
  default     = null
}

variable "ipv6_cidr_block_network_border_group" {
  description = "The network border group for the IPv6 CIDR block. Defaults to the region."
  type        = string
  default     = null
}

# =============================================================================
# IPAM Variables
# =============================================================================

variable "ipv4_ipam_pool_id" {
  description = "The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR."
  type        = string
  default     = null
}

variable "ipv4_netmask_length" {
  description = "The netmask length of the IPv4 CIDR you want to allocate to this VPC."
  type        = number
  default     = null
}

# =============================================================================
# Secondary CIDR Blocks
# =============================================================================

variable "secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool."
  type        = list(string)
  default     = []
}

# =============================================================================
# VPC Block Public Access
# =============================================================================

variable "vpc_block_public_access_exclusion_mode" {
  description = "The mode for VPC Block Public Access exclusion. Valid values: 'allow-bidirectional', 'allow-egress'."
  type        = string
  default     = null
}

# =============================================================================
# Availability Zones
# =============================================================================

variable "azs" {
  description = <<-EOT
    A list of availability zones.
    You can specify just the letter (e.g., ["a", "b", "c"]) and the region will be auto-detected,
    or provide full AZ names (e.g., ["us-east-1a", "us-east-1b"]).
    If not specified, all available AZs in the region will be used (limited by max_azs).
  EOT
  type        = list(string)
  default     = null
}

variable "max_azs" {
  description = "Maximum number of availability zones to use. Use all available if not specified."
  type        = number
  default     = 99
}

# =============================================================================
# Public Subnets Variables
# =============================================================================

variable "public_subnets" {
  description = "A list of public subnets inside the VPC."
  type        = list(string)
  default     = []
}

variable "public_subnet_names" {
  description = "Explicit values to use in the Name tag on public subnets."
  type        = list(string)
  default     = []
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name."
  type        = string
  default     = "public"
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets."
  type        = map(string)
  default     = {}
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch."
  type        = bool
  default     = true
}

variable "public_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on public subnet creation. Requires IPv6 to be enabled."
  type        = bool
  default     = false
}

variable "public_subnet_ipv6_prefixes" {
  description = "Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list."
  type        = list(number)
  default     = []
}

# =============================================================================
# Private Subnets Variables
# =============================================================================

variable "private_subnets" {
  description = "A list of private subnets inside the VPC."
  type        = list(string)
  default     = []
}

variable "private_subnet_names" {
  description = "Explicit values to use in the Name tag on private subnets."
  type        = list(string)
  default     = []
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name."
  type        = string
  default     = "private"
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets."
  type        = map(string)
  default     = {}
}

variable "private_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on private subnet creation. Requires IPv6 to be enabled."
  type        = bool
  default     = false
}

variable "private_subnet_ipv6_prefixes" {
  description = "Assigns IPv6 private subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list."
  type        = list(number)
  default     = []
}

# =============================================================================
# Database Subnets Variables
# =============================================================================

variable "database_subnets" {
  description = "A list of database subnets inside the VPC."
  type        = list(string)
  default     = []
}

variable "database_subnet_names" {
  description = "Explicit values to use in the Name tag on database subnets."
  type        = list(string)
  default     = []
}

variable "database_subnet_suffix" {
  description = "Suffix to append to database subnets name."
  type        = string
  default     = "db"
}

variable "database_subnet_tags" {
  description = "Additional tags for the database subnets."
  type        = map(string)
  default     = {}
}

variable "create_database_subnet_group" {
  description = "Controls if database subnet group should be created (n.b. database_subnets must also be set)."
  type        = bool
  default     = true
}

variable "database_subnet_group_name" {
  description = "Name of database subnet group."
  type        = string
  default     = null
}

variable "database_subnet_group_tags" {
  description = "Additional tags for the database subnet group."
  type        = map(string)
  default     = {}
}

variable "create_database_subnet_route_table" {
  description = "Controls if separate route table for database should be created."
  type        = bool
  default     = false
}

variable "create_database_internet_gateway_route" {
  description = "Controls if an internet gateway route for database should be created."
  type        = bool
  default     = false
}

variable "database_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on database subnet creation. Requires IPv6 to be enabled."
  type        = bool
  default     = false
}

variable "database_subnet_ipv6_prefixes" {
  description = "Assigns IPv6 database subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list."
  type        = list(number)
  default     = []
}

# =============================================================================
# Elasticache Subnets Variables
# =============================================================================

variable "elasticache_subnets" {
  description = "A list of elasticache subnets inside the VPC."
  type        = list(string)
  default     = []
}

variable "elasticache_subnet_names" {
  description = "Explicit values to use in the Name tag on elasticache subnets."
  type        = list(string)
  default     = []
}

variable "elasticache_subnet_suffix" {
  description = "Suffix to append to elasticache subnets name."
  type        = string
  default     = "elasticache"
}

variable "elasticache_subnet_tags" {
  description = "Additional tags for the elasticache subnets."
  type        = map(string)
  default     = {}
}

variable "create_elasticache_subnet_group" {
  description = "Controls if elasticache subnet group should be created."
  type        = bool
  default     = true
}

variable "elasticache_subnet_group_name" {
  description = "Name of elasticache subnet group."
  type        = string
  default     = null
}

variable "elasticache_subnet_group_tags" {
  description = "Additional tags for the elasticache subnet group."
  type        = map(string)
  default     = {}
}

variable "create_elasticache_subnet_route_table" {
  description = "Controls if separate route table for elasticache should be created."
  type        = bool
  default     = false
}

variable "create_elasticache_internet_gateway_route" {
  description = "Controls if an internet gateway route for elasticache should be created."
  type        = bool
  default     = false
}

variable "elasticache_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on elasticache subnet creation. Requires IPv6 to be enabled."
  type        = bool
  default     = false
}

variable "elasticache_subnet_ipv6_prefixes" {
  description = "Assigns IPv6 elasticache subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list."
  type        = list(number)
  default     = []
}

# =============================================================================
# Redshift Subnets Variables
# =============================================================================

variable "redshift_subnets" {
  description = "A list of redshift subnets inside the VPC."
  type        = list(string)
  default     = []
}

variable "redshift_subnet_names" {
  description = "Explicit values to use in the Name tag on redshift subnets."
  type        = list(string)
  default     = []
}

variable "redshift_subnet_suffix" {
  description = "Suffix to append to redshift subnets name."
  type        = string
  default     = "redshift"
}

variable "redshift_subnet_tags" {
  description = "Additional tags for the redshift subnets."
  type        = map(string)
  default     = {}
}

variable "create_redshift_subnet_group" {
  description = "Controls if redshift subnet group should be created."
  type        = bool
  default     = true
}

variable "redshift_subnet_group_name" {
  description = "Name of redshift subnet group."
  type        = string
  default     = null
}

variable "redshift_subnet_group_tags" {
  description = "Additional tags for the redshift subnet group."
  type        = map(string)
  default     = {}
}

variable "create_redshift_subnet_route_table" {
  description = "Controls if separate route table for redshift should be created."
  type        = bool
  default     = false
}

variable "create_redshift_internet_gateway_route" {
  description = "Controls if an internet gateway route for redshift should be created."
  type        = bool
  default     = false
}

variable "redshift_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on redshift subnet creation. Requires IPv6 to be enabled."
  type        = bool
  default     = false
}

variable "redshift_subnet_ipv6_prefixes" {
  description = "Assigns IPv6 redshift subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list."
  type        = list(number)
  default     = []
}

# =============================================================================
# Intra Subnets Variables
# =============================================================================

variable "intra_subnets" {
  description = "A list of intra subnets inside the VPC (no internet access)."
  type        = list(string)
  default     = []
}

variable "intra_subnet_names" {
  description = "Explicit values to use in the Name tag on intra subnets."
  type        = list(string)
  default     = []
}

variable "intra_subnet_suffix" {
  description = "Suffix to append to intra subnets name."
  type        = string
  default     = "intra"
}

variable "intra_subnet_tags" {
  description = "Additional tags for the intra subnets."
  type        = map(string)
  default     = {}
}

variable "intra_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on intra subnet creation. Requires IPv6 to be enabled."
  type        = bool
  default     = false
}

variable "intra_subnet_ipv6_prefixes" {
  description = "Assigns IPv6 intra subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list."
  type        = list(number)
  default     = []
}

# =============================================================================
# Outpost Subnets Variables
# =============================================================================

variable "outpost_subnets" {
  description = "A list of outpost subnets inside the VPC."
  type        = list(string)
  default     = []
}

variable "outpost_subnet_names" {
  description = "Explicit values to use in the Name tag on outpost subnets."
  type        = list(string)
  default     = []
}

variable "outpost_subnet_suffix" {
  description = "Suffix to append to outpost subnets name."
  type        = string
  default     = "outpost"
}

variable "outpost_subnet_tags" {
  description = "Additional tags for the outpost subnets."
  type        = map(string)
  default     = {}
}

variable "outpost_arn" {
  description = "ARN of the Outpost for outpost subnets."
  type        = string
  default     = null
}

# =============================================================================
# Internet Gateway Variables
# =============================================================================

variable "create_igw" {
  description = "Controls if an Internet Gateway is created for public subnets."
  type        = bool
  default     = true
}

variable "create_egress_only_igw" {
  description = "Controls if an Egress Only Internet Gateway is created and attached to the VPC."
  type        = bool
  default     = false
}

# =============================================================================
# NAT Gateway Variables
# =============================================================================

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks."
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks."
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone."
  type        = bool
  default     = false
}

variable "reuse_nat_ips" {
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable."
  type        = bool
  default     = false
}

variable "external_nat_ip_ids" {
  description = "List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)."
  type        = list(string)
  default     = []
}

variable "nat_gateway_tags" {
  description = "Additional tags for the NAT gateways."
  type        = map(string)
  default     = {}
}

variable "nat_eip_tags" {
  description = "Additional tags for the NAT EIP."
  type        = map(string)
  default     = {}
}

# =============================================================================
# VPN Gateway Variables
# =============================================================================

variable "enable_vpn_gateway" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC."
  type        = bool
  default     = false
}

variable "vpn_gateway_id" {
  description = "ID of VPN Gateway to attach to the VPC."
  type        = string
  default     = null
}

variable "amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway."
  type        = string
  default     = "64512"
}

variable "vpn_gateway_az" {
  description = "The Availability Zone for the VPN Gateway."
  type        = string
  default     = null
}

variable "propagate_private_route_tables_vgw" {
  description = "Should be true if you want route table propagation for private route tables."
  type        = bool
  default     = false
}

variable "propagate_public_route_tables_vgw" {
  description = "Should be true if you want route table propagation for public route tables."
  type        = bool
  default     = false
}

variable "propagate_database_route_tables_vgw" {
  description = "Should be true if you want route table propagation for database route tables."
  type        = bool
  default     = false
}

variable "propagate_intra_route_tables_vgw" {
  description = "Should be true if you want route table propagation for intra route tables."
  type        = bool
  default     = false
}

variable "vpn_gateway_tags" {
  description = "Additional tags for the VPN gateway."
  type        = map(string)
  default     = {}
}

# =============================================================================
# DHCP Options Variables
# =============================================================================

variable "enable_dhcp_options" {
  description = "Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type."
  type        = bool
  default     = false
}

variable "dhcp_options_domain_name" {
  description = "Specifies DNS name for DHCP options set (requires enable_dhcp_options set to true)."
  type        = string
  default     = ""
}

variable "dhcp_options_domain_name_servers" {
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable_dhcp_options set to true)."
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "dhcp_options_ntp_servers" {
  description = "Specify a list of NTP servers for DHCP options set (requires enable_dhcp_options set to true)."
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_name_servers" {
  description = "Specify a list of netbios servers for DHCP options set (requires enable_dhcp_options set to true)."
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_node_type" {
  description = "Specify netbios node_type for DHCP options set (requires enable_dhcp_options set to true)."
  type        = string
  default     = ""
}

variable "dhcp_options_tags" {
  description = "Additional tags for the DHCP option set (requires enable_dhcp_options set to true)."
  type        = map(string)
  default     = {}
}

# =============================================================================
# VPC Flow Logs Variables
# =============================================================================

variable "enable_flow_log" {
  description = "Whether or not to enable VPC Flow Logs."
  type        = bool
  default     = false
}

variable "flow_log_destination_type" {
  description = "Type of flow log destination. Can be s3, cloud-watch-logs or kinesis-data-firehose."
  type        = string
  default     = "cloud-watch-logs"

  validation {
    condition     = contains(["s3", "cloud-watch-logs", "kinesis-data-firehose"], var.flow_log_destination_type)
    error_message = "Flow log destination type must be 's3', 'cloud-watch-logs', or 'kinesis-data-firehose'."
  }
}

variable "flow_log_destination_arn" {
  description = "The ARN of the CloudWatch log group, S3 bucket, or Kinesis Data Firehose to send flow logs to."
  type        = string
  default     = null
}

variable "flow_log_traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL."
  type        = string
  default     = "ALL"

  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_log_traffic_type)
    error_message = "Flow log traffic type must be 'ACCEPT', 'REJECT', or 'ALL'."
  }
}

variable "flow_log_log_format" {
  description = "The fields to include in the flow log record."
  type        = string
  default     = null
}

variable "flow_log_max_aggregation_interval" {
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: 60 seconds or 600 seconds."
  type        = number
  default     = 600

  validation {
    condition     = contains([60, 600], var.flow_log_max_aggregation_interval)
    error_message = "Flow log max aggregation interval must be 60 or 600 seconds."
  }
}

variable "flow_log_cloudwatch_log_group_name_prefix" {
  description = "Specifies the name prefix of CloudWatch Log Group for VPC flow logs."
  type        = string
  default     = "/aws/vpc-flow-log/"
}

variable "flow_log_cloudwatch_log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group for VPC flow logs."
  type        = number
  default     = 7
}

variable "flow_log_cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data for VPC flow logs."
  type        = string
  default     = null
}

variable "flow_log_cloudwatch_iam_role_arn" {
  description = "The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group. When flow_log_destination_type is cloud-watch-logs, this argument must be provided."
  type        = string
  default     = null
}

variable "create_flow_log_cloudwatch_iam_role" {
  description = "Whether to create IAM role for VPC flow logs."
  type        = bool
  default     = true
}

variable "flow_log_cloudwatch_iam_role_name" {
  description = "Name to use on the VPC Flow Log CloudWatch IAM role."
  type        = string
  default     = null
}

variable "flow_log_file_format" {
  description = "The format for the flow log. Valid values: plain-text, parquet."
  type        = string
  default     = null
}

variable "flow_log_hive_compatible_partitions" {
  description = "Indicates whether to use Hive-compatible prefixes for flow logs stored in Amazon S3."
  type        = bool
  default     = false
}

variable "flow_log_per_hour_partition" {
  description = "Indicates whether to partition the flow log per hour."
  type        = bool
  default     = false
}

variable "flow_log_cloudwatch_log_group_name" {
  description = "Name of CloudWatch log group for VPC flow logs. If null, will be auto-generated."
  type        = string
  default     = null
}

variable "flow_log_cloudwatch_log_group_arn" {
  description = "ARN of CloudWatch log group for VPC flow logs. If null and destination is CloudWatch, will be auto-created."
  type        = string
  default     = null
}

variable "flow_log_cloudwatch_log_group_tags" {
  description = "Additional tags for the VPC flow log CloudWatch log group."
  type        = map(string)
  default     = {}
}

variable "flow_log_cloudwatch_iam_role_tags" {
  description = "Additional tags for the VPC flow log CloudWatch IAM role."
  type        = map(string)
  default     = {}
}

variable "flow_log_tags" {
  description = "Additional tags for the VPC flow log."
  type        = map(string)
  default     = {}
}

# =============================================================================
# VPC Endpoints Variables
# =============================================================================

variable "enable_s3_endpoint" {
  description = "Should be true if you want to provision an S3 endpoint to the VPC."
  type        = bool
  default     = false
}

variable "enable_dynamodb_endpoint" {
  description = "Should be true if you want to provision a DynamoDB endpoint to the VPC."
  type        = bool
  default     = false
}

variable "vpc_endpoint_tags" {
  description = "Additional tags for the VPC endpoints."
  type        = map(string)
  default     = {}
}

variable "s3_endpoint_tags" {
  description = "Additional tags for the S3 VPC endpoint."
  type        = map(string)
  default     = {}
}

variable "dynamodb_endpoint_tags" {
  description = "Additional tags for the DynamoDB VPC endpoint."
  type        = map(string)
  default     = {}
}

# =============================================================================
# Network ACLs Variables
# =============================================================================

variable "manage_default_network_acl" {
  description = "Should be true to adopt and manage default network ACL."
  type        = bool
  default     = false
}

variable "default_network_acl_name" {
  description = "Name to be used on the default network ACL."
  type        = string
  default     = null
}

variable "default_network_acl_tags" {
  description = "Additional tags for the default network ACL."
  type        = map(string)
  default     = {}
}

variable "public_acl_tags" {
  description = "Additional tags for the public network ACL."
  type        = map(string)
  default     = {}
}

variable "private_acl_tags" {
  description = "Additional tags for the private network ACL."
  type        = map(string)
  default     = {}
}

variable "database_acl_tags" {
  description = "Additional tags for the database network ACL."
  type        = map(string)
  default     = {}
}

variable "elasticache_acl_tags" {
  description = "Additional tags for the elasticache network ACL."
  type        = map(string)
  default     = {}
}

variable "redshift_acl_tags" {
  description = "Additional tags for the redshift network ACL."
  type        = map(string)
  default     = {}
}

variable "intra_acl_tags" {
  description = "Additional tags for the intra network ACL."
  type        = map(string)
  default     = {}
}

variable "public_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for public subnets."
  type        = bool
  default     = false
}

variable "private_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for private subnets."
  type        = bool
  default     = false
}

variable "database_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for database subnets."
  type        = bool
  default     = false
}

variable "elasticache_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for elasticache subnets."
  type        = bool
  default     = false
}

variable "redshift_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for redshift subnets."
  type        = bool
  default     = false
}

variable "intra_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for intra subnets."
  type        = bool
  default     = false
}

# Network ACL Rules
variable "default_network_acl_ingress" {
  description = "List of maps of ingress rules to set on the default network ACL."
  type        = list(map(string))
  default     = []
}

variable "default_network_acl_egress" {
  description = "List of maps of egress rules to set on the default network ACL."
  type        = list(map(string))
  default     = []
}

variable "public_inbound_acl_rules" {
  description = "Public subnets inbound network ACL rules."
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = string
    cidr_block  = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
  }))
  default = []
}

variable "public_outbound_acl_rules" {
  description = "Public subnets outbound network ACL rules."
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = string
    cidr_block  = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
  }))
  default = []
}

variable "private_inbound_acl_rules" {
  description = "Private subnets inbound network ACL rules."
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = string
    cidr_block  = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
  }))
  default = []
}

variable "private_outbound_acl_rules" {
  description = "Private subnets outbound network ACL rules."
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = string
    cidr_block  = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
  }))
  default = []
}

variable "database_inbound_acl_rules" {
  description = "Database subnets inbound network ACL rules."
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = string
    cidr_block  = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
  }))
  default = []
}

variable "database_outbound_acl_rules" {
  description = "Database subnets outbound network ACL rules."
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = string
    cidr_block  = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
  }))
  default = []
}

variable "elasticache_inbound_acl_rules" {
  description = "Elasticache subnets inbound network ACL rules."
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = string
    cidr_block  = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
  }))
  default = []
}

variable "elasticache_outbound_acl_rules" {
  description = "Elasticache subnets outbound network ACL rules."
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = string
    cidr_block  = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
  }))
  default = []
}

variable "redshift_inbound_acl_rules" {
  description = "Redshift subnets inbound network ACL rules."
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = string
    cidr_block  = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
  }))
  default = []
}

variable "redshift_outbound_acl_rules" {
  description = "Redshift subnets outbound network ACL rules."
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = string
    cidr_block  = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
  }))
  default = []
}

variable "intra_inbound_acl_rules" {
  description = "Intra subnets inbound network ACL rules."
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = string
    cidr_block  = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
  }))
  default = []
}

variable "intra_outbound_acl_rules" {
  description = "Intra subnets outbound network ACL rules."
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = string
    cidr_block  = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
  }))
  default = []
}

# =============================================================================
# Naming and Tagging Variables
# =============================================================================

variable "account_name" {
  description = "Account name for resource naming (replaces environment)."
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming."
  type        = string
}

variable "region_prefix" {
  description = "Region prefix for naming. If not provided, will be derived from current region."
  type        = string
  default     = null
}

variable "vpc_name" {
  description = "Name to be used on the VPC. If not provided, will be auto-generated."
  type        = string
  default     = null
}

variable "igw_name" {
  description = "Name to be used on the Internet Gateway. If not provided, will be auto-generated."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "tags_common" {
  description = "DEPRECATED: Use 'tags' instead. A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Additional tags for the VPC."
  type        = map(string)
  default     = {}
}

variable "igw_tags" {
  description = "Additional tags for the internet gateway."
  type        = map(string)
  default     = {}
}

variable "public_route_table_tags" {
  description = "Additional tags for the public route tables."
  type        = map(string)
  default     = {}
}

variable "private_route_table_tags" {
  description = "Additional tags for the private route tables."
  type        = map(string)
  default     = {}
}

variable "database_route_table_tags" {
  description = "Additional tags for the database route tables."
  type        = map(string)
  default     = {}
}

variable "elasticache_route_table_tags" {
  description = "Additional tags for the elasticache route tables."
  type        = map(string)
  default     = {}
}

variable "redshift_route_table_tags" {
  description = "Additional tags for the redshift route tables."
  type        = map(string)
  default     = {}
}

variable "intra_route_table_tags" {
  description = "Additional tags for the intra route tables."
  type        = map(string)
  default     = {}
}
