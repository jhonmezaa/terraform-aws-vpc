################################################################################
# VPC Outputs
################################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.this[0].id, null)
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.this[0].arn, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this[0].cidr_block, null)
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the VPC"
  value       = try(aws_vpc.this[0].ipv6_cidr_block, null)
}

output "vpc_enable_dns_support" {
  description = "Whether DNS support is enabled in the VPC"
  value       = try(aws_vpc.this[0].enable_dns_support, null)
}

output "vpc_enable_dns_hostnames" {
  description = "Whether DNS hostnames are enabled in the VPC"
  value       = try(aws_vpc.this[0].enable_dns_hostnames, null)
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = try(aws_vpc.this[0].main_route_table_id, null)
}

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = try(aws_vpc.this[0].owner_id, null)
}

################################################################################
# Internet Gateway Outputs
################################################################################

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].id, null)
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].arn, null)
}

output "egress_only_igw_id" {
  description = "The ID of the Egress-only Internet Gateway"
  value       = try(aws_egress_only_internet_gateway.this[0].id, null)
}

################################################################################
# Public Subnet Outputs
################################################################################

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = [for subnet in aws_subnet.public : subnet.arn]
}

output "public_subnets_cidr_blocks" {
  description = "List of CIDR blocks of public subnets"
  value       = [for subnet in aws_subnet.public : subnet.cidr_block]
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = try([aws_route_table.public[0].id], [])
}

################################################################################
# Private Subnet Outputs
################################################################################

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = [for subnet in aws_subnet.private : subnet.arn]
}

output "private_subnets_cidr_blocks" {
  description = "List of CIDR blocks of private subnets"
  value       = [for subnet in aws_subnet.private : subnet.cidr_block]
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = [for rt in aws_route_table.private : rt.id]
}

################################################################################
# Database Subnet Outputs
################################################################################

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = [for subnet in aws_subnet.database : subnet.id]
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = [for subnet in aws_subnet.database : subnet.arn]
}

output "database_subnets_cidr_blocks" {
  description = "List of CIDR blocks of database subnets"
  value       = [for subnet in aws_subnet.database : subnet.cidr_block]
}

output "database_subnet_group_id" {
  description = "ID of database subnet group"
  value       = try(aws_db_subnet_group.database[0].id, null)
}

output "database_subnet_group_name" {
  description = "Name of database subnet group"
  value       = try(aws_db_subnet_group.database[0].name, null)
}

output "database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = [for rt in aws_route_table.database : rt.id]
}

################################################################################
# Elasticache Subnet Outputs
################################################################################

output "elasticache_subnets" {
  description = "List of IDs of elasticache subnets"
  value       = [for subnet in aws_subnet.elasticache : subnet.id]
}

output "elasticache_subnet_arns" {
  description = "List of ARNs of elasticache subnets"
  value       = [for subnet in aws_subnet.elasticache : subnet.arn]
}

output "elasticache_subnets_cidr_blocks" {
  description = "List of CIDR blocks of elasticache subnets"
  value       = [for subnet in aws_subnet.elasticache : subnet.cidr_block]
}

output "elasticache_subnet_group_id" {
  description = "ID of elasticache subnet group"
  value       = try(aws_elasticache_subnet_group.elasticache[0].id, null)
}

output "elasticache_subnet_group_name" {
  description = "Name of elasticache subnet group"
  value       = try(aws_elasticache_subnet_group.elasticache[0].name, null)
}

output "elasticache_route_table_ids" {
  description = "List of IDs of elasticache route tables"
  value       = [for rt in aws_route_table.elasticache : rt.id]
}

################################################################################
# Redshift Subnet Outputs
################################################################################

output "redshift_subnets" {
  description = "List of IDs of redshift subnets"
  value       = [for subnet in aws_subnet.redshift : subnet.id]
}

output "redshift_subnet_arns" {
  description = "List of ARNs of redshift subnets"
  value       = [for subnet in aws_subnet.redshift : subnet.arn]
}

output "redshift_subnets_cidr_blocks" {
  description = "List of CIDR blocks of redshift subnets"
  value       = [for subnet in aws_subnet.redshift : subnet.cidr_block]
}

output "redshift_subnet_group_id" {
  description = "ID of redshift subnet group"
  value       = try(aws_redshift_subnet_group.redshift[0].id, null)
}

output "redshift_subnet_group_name" {
  description = "Name of redshift subnet group"
  value       = try(aws_redshift_subnet_group.redshift[0].name, null)
}

output "redshift_route_table_ids" {
  description = "List of IDs of redshift route tables"
  value       = [for rt in aws_route_table.redshift : rt.id]
}

################################################################################
# Intra Subnet Outputs
################################################################################

output "intra_subnets" {
  description = "List of IDs of intra subnets"
  value       = [for subnet in aws_subnet.intra : subnet.id]
}

output "intra_subnet_arns" {
  description = "List of ARNs of intra subnets"
  value       = [for subnet in aws_subnet.intra : subnet.arn]
}

output "intra_subnets_cidr_blocks" {
  description = "List of CIDR blocks of intra subnets"
  value       = [for subnet in aws_subnet.intra : subnet.cidr_block]
}

output "intra_route_table_ids" {
  description = "List of IDs of intra route tables"
  value       = [for rt in aws_route_table.intra : rt.id]
}

################################################################################
# Outpost Subnet Outputs
################################################################################

output "outpost_subnets" {
  description = "List of IDs of outpost subnets"
  value       = [for subnet in aws_subnet.outpost : subnet.id]
}

output "outpost_subnet_arns" {
  description = "List of ARNs of outpost subnets"
  value       = [for subnet in aws_subnet.outpost : subnet.arn]
}

################################################################################
# NAT Gateway Outputs
################################################################################

output "nat_ids" {
  description = "List of NAT Gateway IDs"
  value       = [for nat in aws_nat_gateway.this : nat.id]
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = [for eip in aws_eip.nat : eip.public_ip]
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs (alias for nat_ids)"
  value       = [for nat in aws_nat_gateway.this : nat.id]
}

################################################################################
# VPN Gateway Outputs
################################################################################

output "vgw_id" {
  description = "The ID of the VPN Gateway"
  value       = try(aws_vpn_gateway.this[0].id, var.vpn_gateway_id, null)
}

output "vgw_arn" {
  description = "The ARN of the VPN Gateway"
  value       = try(aws_vpn_gateway.this[0].arn, null)
}

################################################################################
# DHCP Options Outputs
################################################################################

output "dhcp_options_id" {
  description = "The ID of the DHCP options"
  value       = try(aws_vpc_dhcp_options.this[0].id, null)
}

################################################################################
# VPC Endpoints Outputs
################################################################################

output "vpc_endpoint_s3_id" {
  description = "The ID of VPC endpoint for S3"
  value       = try(aws_vpc_endpoint.s3[0].id, null)
}

output "vpc_endpoint_dynamodb_id" {
  description = "The ID of VPC endpoint for DynamoDB"
  value       = try(aws_vpc_endpoint.dynamodb[0].id, null)
}

################################################################################
# VPC Flow Log Outputs
################################################################################

output "vpc_flow_log_id" {
  description = "The ID of the VPC Flow Log"
  value       = try(aws_flow_log.this[0].id, null)
}

output "vpc_flow_log_cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group for VPC Flow Logs"
  value       = try(aws_cloudwatch_log_group.flow_log[0].name, null)
}

output "vpc_flow_log_cloudwatch_iam_role_arn" {
  description = "The ARN of the IAM role used for VPC Flow Logs"
  value       = try(aws_iam_role.flow_log_cloudwatch[0].arn, null)
}

################################################################################
# Network ACL Outputs
################################################################################

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = try(aws_default_network_acl.this[0].id, aws_vpc.this[0].default_network_acl_id, null)
}

output "public_network_acl_id" {
  description = "The ID of the public network ACL"
  value       = try(aws_network_acl.public[0].id, null)
}

output "public_network_acl_arn" {
  description = "The ARN of the public network ACL"
  value       = try(aws_network_acl.public[0].arn, null)
}

output "private_network_acl_id" {
  description = "The ID of the private network ACL"
  value       = try(aws_network_acl.private[0].id, null)
}

output "private_network_acl_arn" {
  description = "The ARN of the private network ACL"
  value       = try(aws_network_acl.private[0].arn, null)
}

output "database_network_acl_id" {
  description = "The ID of the database network ACL"
  value       = try(aws_network_acl.database[0].id, null)
}

output "database_network_acl_arn" {
  description = "The ARN of the database network ACL"
  value       = try(aws_network_acl.database[0].arn, null)
}

output "elasticache_network_acl_id" {
  description = "The ID of the elasticache network ACL"
  value       = try(aws_network_acl.elasticache[0].id, null)
}

output "elasticache_network_acl_arn" {
  description = "The ARN of the elasticache network ACL"
  value       = try(aws_network_acl.elasticache[0].arn, null)
}

output "redshift_network_acl_id" {
  description = "The ID of the redshift network ACL"
  value       = try(aws_network_acl.redshift[0].id, null)
}

output "redshift_network_acl_arn" {
  description = "The ARN of the redshift network ACL"
  value       = try(aws_network_acl.redshift[0].arn, null)
}

output "intra_network_acl_id" {
  description = "The ID of the intra network ACL"
  value       = try(aws_network_acl.intra[0].id, null)
}

output "intra_network_acl_arn" {
  description = "The ARN of the intra network ACL"
  value       = try(aws_network_acl.intra[0].arn, null)
}

################################################################################
# Availability Zone Outputs
################################################################################

output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = local.azs
}

output "name" {
  description = "The name of the VPC"
  value       = local.vpc_name
}
