################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  count = local.create_vpc ? 1 : 0

  # CIDR configuration - supports both manual CIDR or IPAM
  cidr_block          = var.vpc_cidr_block
  ipv4_ipam_pool_id   = var.ipv4_ipam_pool_id
  ipv4_netmask_length = var.ipv4_netmask_length

  # IPv6 configuration
  assign_generated_ipv6_cidr_block     = var.enable_ipv6 && var.ipv6_cidr_block == null ? true : false
  ipv6_cidr_block                      = var.ipv6_cidr_block
  ipv6_ipam_pool_id                    = var.ipv6_ipam_pool_id
  ipv6_netmask_length                  = var.ipv6_netmask_length
  ipv6_cidr_block_network_border_group = var.ipv6_cidr_block_network_border_group

  # Instance tenancy
  instance_tenancy = var.instance_tenancy

  # DNS configuration
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  # Network address usage metrics (for IPAM)
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics

  tags = local.vpc_tags
}

################################################################################
# Secondary CIDR Blocks
################################################################################

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  for_each = toset(var.secondary_cidr_blocks)

  vpc_id = aws_vpc.this[0].id

  cidr_block = each.value
}

################################################################################
# VPC Block Public Access (BPA)
# Prevents unwanted public IP assignments
################################################################################

resource "aws_vpc_block_public_access_exclusion" "this" {
  count = local.create_vpc && var.vpc_block_public_access_exclusion_mode != null ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  internet_gateway_exclusion_mode = var.vpc_block_public_access_exclusion_mode
}
