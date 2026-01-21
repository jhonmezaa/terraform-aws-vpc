################################################################################
# Locals - Centralized Logic
################################################################################

locals {
  # Region prefix mapping - consistent with other modules (EKS, Security Group)
  region_prefix_map = {
    us-east-1      = "ause1"
    us-east-2      = "ause2"
    us-west-1      = "usw1"
    us-west-2      = "usw2"
    eu-west-1      = "euw1"
    eu-west-2      = "euw2"
    eu-west-3      = "euw3"
    eu-central-1   = "euc1"
    eu-north-1     = "eun1"
    eu-south-1     = "eus1"
    ap-south-1     = "aps1"
    ap-northeast-1 = "apne1"
    ap-northeast-2 = "apne2"
    ap-northeast-3 = "apne3"
    ap-southeast-1 = "apse1"
    ap-southeast-2 = "apse2"
    ap-east-1      = "ape1"
    ca-central-1   = "cac1"
    sa-east-1      = "sae1"
    me-south-1     = "mes1"
    af-south-1     = "afs1"
  }

  # Determine region prefix (use provided or derive from current region)
  region_prefix = var.region_prefix != null ? var.region_prefix : lookup(local.region_prefix_map, data.aws_region.current.id, "unknown")

  # VPC creation flag
  create_vpc = var.create_vpc

  ################################################################################
  # Availability Zones
  ################################################################################

  # Get available AZs (limited to max_azs if specified, otherwise use all)
  len_available_azs = min(length(data.aws_availability_zones.available.names), var.max_azs)
  available_azs     = slice(data.aws_availability_zones.available.names, 0, local.len_available_azs)

  # Build full AZ names from short format (e.g., "a" -> "us-east-1a")
  # If user provides just letters (a, b, c), prepend the current region
  # If user provides full AZ names (us-east-1a), use them as-is
  azs = var.azs != null ? [
    for az in var.azs :
    length(az) == 1 ? "${data.aws_region.current.id}${az}" : az
  ] : local.available_azs

  # Number of AZs
  len_azs = length(local.azs)

  ################################################################################
  # Subnet Calculations
  ################################################################################

  # Public subnets
  len_public_subnets      = max(length(var.public_subnets))
  create_public_subnets   = local.create_vpc && local.len_public_subnets > 0
  create_public_route_table = local.create_public_subnets

  # Private subnets
  len_private_subnets    = max(length(var.private_subnets))
  create_private_subnets = local.create_vpc && local.len_private_subnets > 0

  # Database subnets
  len_database_subnets      = max(length(var.database_subnets))
  create_database_subnets   = local.create_vpc && local.len_database_subnets > 0
  create_database_subnet_group = local.create_database_subnets && var.create_database_subnet_group

  # Elasticache subnets
  len_elasticache_subnets      = max(length(var.elasticache_subnets))
  create_elasticache_subnets   = local.create_vpc && local.len_elasticache_subnets > 0
  create_elasticache_subnet_group = local.create_elasticache_subnets && var.create_elasticache_subnet_group

  # Redshift subnets
  len_redshift_subnets      = max(length(var.redshift_subnets))
  create_redshift_subnets   = local.create_vpc && local.len_redshift_subnets > 0
  create_redshift_subnet_group = local.create_redshift_subnets && var.create_redshift_subnet_group

  # Intra subnets (no internet access)
  len_intra_subnets    = max(length(var.intra_subnets))
  create_intra_subnets = local.create_vpc && local.len_intra_subnets > 0

  # Outpost subnets
  len_outpost_subnets    = max(length(var.outpost_subnets))
  create_outpost_subnets = local.create_vpc && local.len_outpost_subnets > 0

  ################################################################################
  # NAT Gateway Logic
  ################################################################################

  # Determine if NAT Gateway should be created
  enable_nat_gateway = var.enable_nat_gateway && local.create_public_subnets && local.create_private_subnets

  # Calculate number of NAT Gateways based on strategy
  # - If single_nat_gateway = true: create 1 NAT
  # - If one_nat_gateway_per_az = true: create 1 NAT per AZ
  # - Otherwise: create 1 NAT per private subnet (default)
  nat_gateway_count = local.enable_nat_gateway ? (
    var.single_nat_gateway ? 1 : (
      var.one_nat_gateway_per_az ? local.len_azs : local.len_private_subnets
    )
  ) : 0

  # Determine which public subnets will have NAT Gateways
  # - If single_nat_gateway: use first public subnet
  # - If one_nat_gateway_per_az: use first public subnet in each AZ
  # - Otherwise: use corresponding public subnet for each private subnet
  nat_gateway_public_subnet_indices = local.enable_nat_gateway ? (
    var.single_nat_gateway ? [0] : (
      var.one_nat_gateway_per_az ? range(0, local.len_azs) : range(0, local.len_private_subnets)
    )
  ) : []

  # Reuse NAT IPs logic
  reuse_nat_ips = var.reuse_nat_ips && var.external_nat_ip_ids != []

  ################################################################################
  # Internet Gateway
  ################################################################################

  create_igw              = local.create_vpc && var.create_igw && local.create_public_subnets
  create_egress_only_igw  = local.create_vpc && var.create_egress_only_igw && var.enable_ipv6

  ################################################################################
  # VPN Gateway
  ################################################################################

  create_vpn_gateway = local.create_vpc && var.enable_vpn_gateway
  enable_vpn_gateway = var.enable_vpn_gateway

  ################################################################################
  # DHCP Options
  ################################################################################

  create_dhcp_options = local.create_vpc && var.enable_dhcp_options

  ################################################################################
  # Flow Logs
  ################################################################################

  enable_flow_log = local.create_vpc && var.enable_flow_log

  # Create CloudWatch log group if destination is CloudWatch and not provided
  create_flow_log_cloudwatch_log_group = local.enable_flow_log && var.flow_log_destination_type == "cloud-watch-logs" && var.flow_log_cloudwatch_log_group_name == null

  # Create CloudWatch IAM role if destination is CloudWatch and enabled
  create_flow_log_cloudwatch_iam_role = local.enable_flow_log && var.flow_log_destination_type == "cloud-watch-logs" && var.create_flow_log_cloudwatch_iam_role

  ################################################################################
  # VPC Endpoints
  ################################################################################

  create_vpc_endpoints = local.create_vpc

  ################################################################################
  # Network ACLs
  ################################################################################

  manage_default_network_acl    = local.create_vpc && var.manage_default_network_acl
  create_public_network_acl     = local.create_public_subnets && var.public_dedicated_network_acl
  create_private_network_acl    = local.create_private_subnets && var.private_dedicated_network_acl
  create_database_network_acl   = local.create_database_subnets && var.database_dedicated_network_acl
  create_elasticache_network_acl = local.create_elasticache_subnets && var.elasticache_dedicated_network_acl
  create_redshift_network_acl   = local.create_redshift_subnets && var.redshift_dedicated_network_acl
  create_intra_network_acl      = local.create_intra_subnets && var.intra_dedicated_network_acl

  ################################################################################
  # Naming Conventions
  ################################################################################

  # Base name components
  name_prefix = "${local.region_prefix}-${var.account_name}-${var.project_name}"

  # VPC name
  vpc_name = var.vpc_name != null ? var.vpc_name : "${local.region_prefix}-vpc-${var.account_name}-${var.project_name}"

  # Internet Gateway name
  igw_name = var.igw_name != null ? var.igw_name : "${local.region_prefix}-igw-${var.account_name}-${var.project_name}"

  # Egress-only Internet Gateway name
  eigw_name = "${local.region_prefix}-eigw-${var.account_name}-${var.project_name}"

  # VPN Gateway name
  vpn_gateway_name = "${local.region_prefix}-vgw-${var.account_name}-${var.project_name}"

  # DHCP Options name
  dhcp_options_name = "${local.region_prefix}-dhcp-${var.account_name}-${var.project_name}"

  # Default Network ACL name
  default_network_acl_name = var.default_network_acl_name != null ? var.default_network_acl_name : "${local.region_prefix}-nacl-default-${var.account_name}-${var.project_name}"

  ################################################################################
  # Subnet Naming
  ################################################################################

  # Public subnet names
  public_subnet_names = length(var.public_subnet_names) > 0 ? var.public_subnet_names : [
    for i, cidr in var.public_subnets :
    "${local.region_prefix}-subnet-${var.public_subnet_suffix}-${var.account_name}-${var.project_name}-${element(local.azs, i)}"
  ]

  # Private subnet names
  private_subnet_names = length(var.private_subnet_names) > 0 ? var.private_subnet_names : [
    for i, cidr in var.private_subnets :
    "${local.region_prefix}-subnet-${var.private_subnet_suffix}-${var.account_name}-${var.project_name}-${element(local.azs, i)}"
  ]

  # Database subnet names
  database_subnet_names = length(var.database_subnet_names) > 0 ? var.database_subnet_names : [
    for i, cidr in var.database_subnets :
    "${local.region_prefix}-subnet-${var.database_subnet_suffix}-${var.account_name}-${var.project_name}-${element(local.azs, i)}"
  ]

  # Elasticache subnet names
  elasticache_subnet_names = length(var.elasticache_subnet_names) > 0 ? var.elasticache_subnet_names : [
    for i, cidr in var.elasticache_subnets :
    "${local.region_prefix}-subnet-${var.elasticache_subnet_suffix}-${var.account_name}-${var.project_name}-${element(local.azs, i)}"
  ]

  # Redshift subnet names
  redshift_subnet_names = length(var.redshift_subnet_names) > 0 ? var.redshift_subnet_names : [
    for i, cidr in var.redshift_subnets :
    "${local.region_prefix}-subnet-${var.redshift_subnet_suffix}-${var.account_name}-${var.project_name}-${element(local.azs, i)}"
  ]

  # Intra subnet names
  intra_subnet_names = length(var.intra_subnet_names) > 0 ? var.intra_subnet_names : [
    for i, cidr in var.intra_subnets :
    "${local.region_prefix}-subnet-${var.intra_subnet_suffix}-${var.account_name}-${var.project_name}-${element(local.azs, i)}"
  ]

  # Outpost subnet names
  outpost_subnet_names = length(var.outpost_subnet_names) > 0 ? var.outpost_subnet_names : [
    for i, cidr in var.outpost_subnets :
    "${local.region_prefix}-subnet-${var.outpost_subnet_suffix}-${var.account_name}-${var.project_name}-${element(local.azs, i)}"
  ]

  ################################################################################
  # Route Table Naming
  ################################################################################

  # Public route table name (single for all public subnets)
  public_route_table_name = "${local.region_prefix}-rtb-${var.public_subnet_suffix}-${var.account_name}-${var.project_name}"

  # Private route table names (per AZ if one_nat_gateway_per_az, otherwise per subnet)
  private_route_table_names = [
    for i in range(local.len_private_subnets) :
    "${local.region_prefix}-rtb-${var.private_subnet_suffix}-${var.account_name}-${var.project_name}-${element(local.azs, i)}"
  ]

  # Database route table names
  database_route_table_names = var.create_database_subnet_route_table ? [
    for i in range(local.len_database_subnets) :
    "${local.region_prefix}-rtb-${var.database_subnet_suffix}-${var.account_name}-${var.project_name}-${element(local.azs, i)}"
  ] : []

  # Elasticache route table names
  elasticache_route_table_names = var.create_elasticache_subnet_route_table ? [
    for i in range(local.len_elasticache_subnets) :
    "${local.region_prefix}-rtb-${var.elasticache_subnet_suffix}-${var.account_name}-${var.project_name}-${element(local.azs, i)}"
  ] : []

  # Redshift route table names
  redshift_route_table_names = var.create_redshift_subnet_route_table ? [
    for i in range(local.len_redshift_subnets) :
    "${local.region_prefix}-rtb-${var.redshift_subnet_suffix}-${var.account_name}-${var.project_name}-${element(local.azs, i)}"
  ] : []

  # Intra route table names
  intra_route_table_names = [
    for i in range(local.len_intra_subnets) :
    "${local.region_prefix}-rtb-${var.intra_subnet_suffix}-${var.account_name}-${var.project_name}-${element(local.azs, i)}"
  ]

  ################################################################################
  # NAT Gateway Naming
  ################################################################################

  nat_gateway_names = [
    for i in range(local.nat_gateway_count) :
    "${local.region_prefix}-nat-${var.account_name}-${var.project_name}-${element(local.azs, i)}"
  ]

  ################################################################################
  # Elastic IP Naming
  ################################################################################

  eip_names = [
    for i in range(local.nat_gateway_count) :
    "${local.region_prefix}-eip-nat-${var.account_name}-${var.project_name}-${element(local.azs, i)}"
  ]

  ################################################################################
  # Database Subnet Group Naming
  ################################################################################

  database_subnet_group_name = var.database_subnet_group_name != null ? var.database_subnet_group_name : "${local.region_prefix}-dbsubnetgroup-${var.account_name}-${var.project_name}"

  ################################################################################
  # Elasticache Subnet Group Naming
  ################################################################################

  elasticache_subnet_group_name = var.elasticache_subnet_group_name != null ? var.elasticache_subnet_group_name : "${local.region_prefix}-ecsubnetgroup-${var.account_name}-${var.project_name}"

  ################################################################################
  # Redshift Subnet Group Naming
  ################################################################################

  redshift_subnet_group_name = var.redshift_subnet_group_name != null ? var.redshift_subnet_group_name : "${local.region_prefix}-rssubnetgroup-${var.account_name}-${var.project_name}"

  ################################################################################
  # Flow Logs Naming
  ################################################################################

  flow_log_cloudwatch_log_group_name = var.flow_log_cloudwatch_log_group_name != null ? var.flow_log_cloudwatch_log_group_name : "/aws/vpc/flowlogs/${local.vpc_name}"
  flow_log_cloudwatch_iam_role_name  = "${local.region_prefix}-role-vpcflowlogs-${var.account_name}-${var.project_name}"

  ################################################################################
  # Tagging
  ################################################################################

  # Common tags applied to all resources
  common_tags = merge(
    {
      ManagedBy   = "Terraform"
      Project     = var.project_name
      Account     = var.account_name
      Region      = data.aws_region.current.id
      RegionCode  = local.region_prefix
    },
    var.tags
  )

  # VPC tags
  vpc_tags = merge(
    {
      Name = local.vpc_name
    },
    local.common_tags,
    var.vpc_tags
  )

  # Internet Gateway tags
  igw_tags = merge(
    {
      Name = local.igw_name
    },
    local.common_tags,
    var.igw_tags
  )

  # DHCP Options tags
  dhcp_options_tags = merge(
    {
      Name = local.dhcp_options_name
    },
    local.common_tags,
    var.dhcp_options_tags
  )

  # VPN Gateway tags
  vpn_gateway_tags = merge(
    {
      Name = local.vpn_gateway_name
    },
    local.common_tags,
    var.vpn_gateway_tags
  )

  # Default Network ACL tags
  default_network_acl_tags = merge(
    {
      Name = local.default_network_acl_name
    },
    local.common_tags,
    var.default_network_acl_tags
  )
}
