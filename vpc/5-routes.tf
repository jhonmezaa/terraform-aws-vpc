################################################################################
# Public Route Table
# Single route table for all public subnets
################################################################################

resource "aws_route_table" "public" {
  count = local.create_public_route_table ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    {
      Name = local.public_route_table_name
      Type = "public"
    },
    local.common_tags,
    var.public_route_table_tags
  )
}

# Public route to Internet Gateway (IPv4)
resource "aws_route" "public_internet_gateway" {
  count = local.create_igw ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

# Public route to Internet Gateway (IPv6)
resource "aws_route" "public_internet_gateway_ipv6" {
  count = local.create_igw && var.enable_ipv6 ? 1 : 0

  route_table_id              = aws_route_table.public[0].id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

# Public Subnet Route Table Associations
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[0].id
}

################################################################################
# Private Route Tables
# One route table per private subnet (or per AZ if one_nat_gateway_per_az)
################################################################################

resource "aws_route_table" "private" {
  for_each = local.create_private_subnets ? toset([
    for i in range(local.len_private_subnets) : tostring(i)
  ]) : toset([])

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    {
      Name = local.private_route_table_names[tonumber(each.key)]
      Type = "private"
    },
    local.common_tags,
    var.private_route_table_tags
  )
}

# Private route to NAT Gateway (IPv4)
resource "aws_route" "private_nat_gateway" {
  for_each = local.enable_nat_gateway ? toset([
    for i in range(local.len_private_subnets) : tostring(i)
  ]) : toset([])

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"

  # Route to appropriate NAT Gateway based on strategy
  nat_gateway_id = element(
    [for nat in aws_nat_gateway.this : nat.id],
    var.single_nat_gateway ? 0 : (
      var.one_nat_gateway_per_az ? tonumber(each.key) % local.len_azs : tonumber(each.key)
    )
  )

  timeouts {
    create = "5m"
  }
}

# Private route to Egress-only Internet Gateway (IPv6)
resource "aws_route" "private_egress_only_igw" {
  for_each = local.create_egress_only_igw && local.create_private_subnets ? toset([
    for i in range(local.len_private_subnets) : tostring(i)
  ]) : toset([])

  route_table_id              = aws_route_table.private[each.key].id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

# Private Subnet Route Table Associations
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

################################################################################
# Database Route Tables
################################################################################

resource "aws_route_table" "database" {
  for_each = local.create_database_subnets && var.create_database_subnet_route_table ? toset([
    for i in range(local.len_database_subnets) : tostring(i)
  ]) : toset([])

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    {
      Name = local.database_route_table_names[tonumber(each.key)]
      Type = "database"
    },
    local.common_tags,
    var.database_route_table_tags
  )
}

# Database route to NAT Gateway if enabled
resource "aws_route" "database_nat_gateway" {
  for_each = local.enable_nat_gateway && var.create_database_subnet_route_table && var.create_database_internet_gateway_route ? toset([
    for i in range(local.len_database_subnets) : tostring(i)
  ]) : toset([])

  route_table_id         = aws_route_table.database[each.key].id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = element(
    [for nat in aws_nat_gateway.this : nat.id],
    var.single_nat_gateway ? 0 : (
      var.one_nat_gateway_per_az ? tonumber(each.key) % local.len_azs : tonumber(each.key)
    )
  )

  timeouts {
    create = "5m"
  }
}

# Database Subnet Route Table Associations
resource "aws_route_table_association" "database" {
  for_each = var.create_database_subnet_route_table ? aws_subnet.database : {}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.database[each.key].id
}

################################################################################
# Elasticache Route Tables
################################################################################

resource "aws_route_table" "elasticache" {
  for_each = local.create_elasticache_subnets && var.create_elasticache_subnet_route_table ? toset([
    for i in range(local.len_elasticache_subnets) : tostring(i)
  ]) : toset([])

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    {
      Name = local.elasticache_route_table_names[tonumber(each.key)]
      Type = "elasticache"
    },
    local.common_tags,
    var.elasticache_route_table_tags
  )
}

# Elasticache route to NAT Gateway if enabled
resource "aws_route" "elasticache_nat_gateway" {
  for_each = local.enable_nat_gateway && var.create_elasticache_subnet_route_table && var.create_elasticache_internet_gateway_route ? toset([
    for i in range(local.len_elasticache_subnets) : tostring(i)
  ]) : toset([])

  route_table_id         = aws_route_table.elasticache[each.key].id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = element(
    [for nat in aws_nat_gateway.this : nat.id],
    var.single_nat_gateway ? 0 : (
      var.one_nat_gateway_per_az ? tonumber(each.key) % local.len_azs : tonumber(each.key)
    )
  )

  timeouts {
    create = "5m"
  }
}

# Elasticache Subnet Route Table Associations
resource "aws_route_table_association" "elasticache" {
  for_each = var.create_elasticache_subnet_route_table ? aws_subnet.elasticache : {}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.elasticache[each.key].id
}

################################################################################
# Redshift Route Tables
################################################################################

resource "aws_route_table" "redshift" {
  for_each = local.create_redshift_subnets && var.create_redshift_subnet_route_table ? toset([
    for i in range(local.len_redshift_subnets) : tostring(i)
  ]) : toset([])

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    {
      Name = local.redshift_route_table_names[tonumber(each.key)]
      Type = "redshift"
    },
    local.common_tags,
    var.redshift_route_table_tags
  )
}

# Redshift route to NAT Gateway if enabled
resource "aws_route" "redshift_nat_gateway" {
  for_each = local.enable_nat_gateway && var.create_redshift_subnet_route_table && var.create_redshift_internet_gateway_route ? toset([
    for i in range(local.len_redshift_subnets) : tostring(i)
  ]) : toset([])

  route_table_id         = aws_route_table.redshift[each.key].id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = element(
    [for nat in aws_nat_gateway.this : nat.id],
    var.single_nat_gateway ? 0 : (
      var.one_nat_gateway_per_az ? tonumber(each.key) % local.len_azs : tonumber(each.key)
    )
  )

  timeouts {
    create = "5m"
  }
}

# Redshift Subnet Route Table Associations
resource "aws_route_table_association" "redshift" {
  for_each = var.create_redshift_subnet_route_table ? aws_subnet.redshift : {}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.redshift[each.key].id
}

################################################################################
# Intra Route Tables
# For subnets with no internet access
################################################################################

resource "aws_route_table" "intra" {
  for_each = local.create_intra_subnets ? toset([
    for i in range(local.len_intra_subnets) : tostring(i)
  ]) : toset([])

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    {
      Name = local.intra_route_table_names[tonumber(each.key)]
      Type = "intra"
    },
    local.common_tags,
    var.intra_route_table_tags
  )
}

# Intra Subnet Route Table Associations
resource "aws_route_table_association" "intra" {
  for_each = aws_subnet.intra

  subnet_id      = each.value.id
  route_table_id = aws_route_table.intra[each.key].id
}

################################################################################
# VPN Gateway Route Propagation
################################################################################

# Propagate VPN Gateway routes to public route tables
resource "aws_vpn_gateway_route_propagation" "public" {
  count = local.enable_vpn_gateway && var.propagate_public_route_tables_vgw ? 1 : 0

  route_table_id = aws_route_table.public[0].id
  vpn_gateway_id = var.vpn_gateway_id != null ? var.vpn_gateway_id : aws_vpn_gateway.this[0].id
}

# Propagate VPN Gateway routes to private route tables
resource "aws_vpn_gateway_route_propagation" "private" {
  for_each = local.enable_vpn_gateway && var.propagate_private_route_tables_vgw ? aws_route_table.private : {}

  route_table_id = each.value.id
  vpn_gateway_id = var.vpn_gateway_id != null ? var.vpn_gateway_id : aws_vpn_gateway.this[0].id
}

# Propagate VPN Gateway routes to database route tables
resource "aws_vpn_gateway_route_propagation" "database" {
  for_each = local.enable_vpn_gateway && var.propagate_database_route_tables_vgw && var.create_database_subnet_route_table ? aws_route_table.database : {}

  route_table_id = each.value.id
  vpn_gateway_id = var.vpn_gateway_id != null ? var.vpn_gateway_id : aws_vpn_gateway.this[0].id
}

# Propagate VPN Gateway routes to intra route tables
resource "aws_vpn_gateway_route_propagation" "intra" {
  for_each = local.enable_vpn_gateway && var.propagate_intra_route_tables_vgw ? aws_route_table.intra : {}

  route_table_id = each.value.id
  vpn_gateway_id = var.vpn_gateway_id != null ? var.vpn_gateway_id : aws_vpn_gateway.this[0].id
}
