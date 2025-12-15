################################################################################
# Public Subnets
################################################################################

resource "aws_subnet" "public" {
  for_each = local.create_public_subnets ? {
    for idx, cidr in var.public_subnets : idx => {
      cidr = cidr
      az   = element(local.azs, idx)
      name = element(local.public_subnet_names, idx)
    }
  } : {}

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  # IPv6 configuration
  assign_ipv6_address_on_creation = var.enable_ipv6 && var.public_subnet_assign_ipv6_address_on_creation ? true : false
  ipv6_cidr_block = var.enable_ipv6 && length(var.public_subnet_ipv6_prefixes) > 0 ? cidrsubnet(
    aws_vpc.this[0].ipv6_cidr_block,
    8,
    var.public_subnet_ipv6_prefixes[each.key]
  ) : null

  # Auto-assign public IPv4 addresses
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      Name = each.value.name
      Type = "public"
    },
    local.common_tags,
    var.public_subnet_tags
  )
}

################################################################################
# Private Subnets
################################################################################

resource "aws_subnet" "private" {
  for_each = local.create_private_subnets ? {
    for idx, cidr in var.private_subnets : idx => {
      cidr = cidr
      az   = element(local.azs, idx)
      name = element(local.private_subnet_names, idx)
    }
  } : {}

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  # IPv6 configuration
  assign_ipv6_address_on_creation = var.enable_ipv6 && var.private_subnet_assign_ipv6_address_on_creation ? true : false
  ipv6_cidr_block = var.enable_ipv6 && length(var.private_subnet_ipv6_prefixes) > 0 ? cidrsubnet(
    aws_vpc.this[0].ipv6_cidr_block,
    8,
    var.private_subnet_ipv6_prefixes[each.key]
  ) : null

  tags = merge(
    {
      Name = each.value.name
      Type = "private"
    },
    local.common_tags,
    var.private_subnet_tags
  )
}

################################################################################
# Database Subnets
################################################################################

resource "aws_subnet" "database" {
  for_each = local.create_database_subnets ? {
    for idx, cidr in var.database_subnets : idx => {
      cidr = cidr
      az   = element(local.azs, idx)
      name = element(local.database_subnet_names, idx)
    }
  } : {}

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  # IPv6 configuration
  assign_ipv6_address_on_creation = var.enable_ipv6 && var.database_subnet_assign_ipv6_address_on_creation ? true : false
  ipv6_cidr_block = var.enable_ipv6 && length(var.database_subnet_ipv6_prefixes) > 0 ? cidrsubnet(
    aws_vpc.this[0].ipv6_cidr_block,
    8,
    var.database_subnet_ipv6_prefixes[each.key]
  ) : null

  tags = merge(
    {
      Name = each.value.name
      Type = "database"
    },
    local.common_tags,
    var.database_subnet_tags
  )
}

# Database Subnet Group
resource "aws_db_subnet_group" "database" {
  count = local.create_database_subnet_group ? 1 : 0

  name        = local.database_subnet_group_name
  description = "Database subnet group for ${local.vpc_name}"
  subnet_ids  = [for subnet in aws_subnet.database : subnet.id]

  tags = merge(
    {
      Name = local.database_subnet_group_name
    },
    local.common_tags,
    var.database_subnet_group_tags
  )
}

################################################################################
# Elasticache Subnets
################################################################################

resource "aws_subnet" "elasticache" {
  for_each = local.create_elasticache_subnets ? {
    for idx, cidr in var.elasticache_subnets : idx => {
      cidr = cidr
      az   = element(local.azs, idx)
      name = element(local.elasticache_subnet_names, idx)
    }
  } : {}

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  # IPv6 configuration
  assign_ipv6_address_on_creation = var.enable_ipv6 && var.elasticache_subnet_assign_ipv6_address_on_creation ? true : false
  ipv6_cidr_block = var.enable_ipv6 && length(var.elasticache_subnet_ipv6_prefixes) > 0 ? cidrsubnet(
    aws_vpc.this[0].ipv6_cidr_block,
    8,
    var.elasticache_subnet_ipv6_prefixes[each.key]
  ) : null

  tags = merge(
    {
      Name = each.value.name
      Type = "elasticache"
    },
    local.common_tags,
    var.elasticache_subnet_tags
  )
}

# Elasticache Subnet Group
resource "aws_elasticache_subnet_group" "elasticache" {
  count = local.create_elasticache_subnet_group ? 1 : 0

  name        = local.elasticache_subnet_group_name
  description = "Elasticache subnet group for ${local.vpc_name}"
  subnet_ids  = [for subnet in aws_subnet.elasticache : subnet.id]

  tags = merge(
    {
      Name = local.elasticache_subnet_group_name
    },
    local.common_tags,
    var.elasticache_subnet_group_tags
  )
}

################################################################################
# Redshift Subnets
################################################################################

resource "aws_subnet" "redshift" {
  for_each = local.create_redshift_subnets ? {
    for idx, cidr in var.redshift_subnets : idx => {
      cidr = cidr
      az   = element(local.azs, idx)
      name = element(local.redshift_subnet_names, idx)
    }
  } : {}

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  # IPv6 configuration
  assign_ipv6_address_on_creation = var.enable_ipv6 && var.redshift_subnet_assign_ipv6_address_on_creation ? true : false
  ipv6_cidr_block = var.enable_ipv6 && length(var.redshift_subnet_ipv6_prefixes) > 0 ? cidrsubnet(
    aws_vpc.this[0].ipv6_cidr_block,
    8,
    var.redshift_subnet_ipv6_prefixes[each.key]
  ) : null

  tags = merge(
    {
      Name = each.value.name
      Type = "redshift"
    },
    local.common_tags,
    var.redshift_subnet_tags
  )
}

# Redshift Subnet Group
resource "aws_redshift_subnet_group" "redshift" {
  count = local.create_redshift_subnet_group ? 1 : 0

  name        = local.redshift_subnet_group_name
  description = "Redshift subnet group for ${local.vpc_name}"
  subnet_ids  = [for subnet in aws_subnet.redshift : subnet.id]

  tags = merge(
    {
      Name = local.redshift_subnet_group_name
    },
    local.common_tags,
    var.redshift_subnet_group_tags
  )
}

################################################################################
# Intra Subnets (no internet access)
################################################################################

resource "aws_subnet" "intra" {
  for_each = local.create_intra_subnets ? {
    for idx, cidr in var.intra_subnets : idx => {
      cidr = cidr
      az   = element(local.azs, idx)
      name = element(local.intra_subnet_names, idx)
    }
  } : {}

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  # IPv6 configuration
  assign_ipv6_address_on_creation = var.enable_ipv6 && var.intra_subnet_assign_ipv6_address_on_creation ? true : false
  ipv6_cidr_block = var.enable_ipv6 && length(var.intra_subnet_ipv6_prefixes) > 0 ? cidrsubnet(
    aws_vpc.this[0].ipv6_cidr_block,
    8,
    var.intra_subnet_ipv6_prefixes[each.key]
  ) : null

  tags = merge(
    {
      Name = each.value.name
      Type = "intra"
    },
    local.common_tags,
    var.intra_subnet_tags
  )
}

################################################################################
# Outpost Subnets
################################################################################

resource "aws_subnet" "outpost" {
  for_each = local.create_outpost_subnets ? {
    for idx, cidr in var.outpost_subnets : idx => {
      cidr      = cidr
      az        = element(local.azs, idx)
      name      = element(local.outpost_subnet_names, idx)
      outpost_arn = var.outpost_arn
    }
  } : {}

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  outpost_arn       = each.value.outpost_arn

  tags = merge(
    {
      Name = each.value.name
      Type = "outpost"
    },
    local.common_tags,
    var.outpost_subnet_tags
  )
}
