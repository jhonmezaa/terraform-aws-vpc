################################################################################
# Network ACLs (NACLs)
################################################################################

################################################################################
# Default Network ACL
################################################################################

resource "aws_default_network_acl" "this" {
  count = local.manage_default_network_acl ? 1 : 0

  default_network_acl_id = aws_vpc.this[0].default_network_acl_id

  # Default deny all inbound and outbound
  # Users can add custom rules via default_network_acl_ingress/egress variables

  dynamic "ingress" {
    for_each = var.default_network_acl_ingress
    content {
      rule_no    = ingress.value.rule_number
      protocol   = ingress.value.protocol
      action     = ingress.value.rule_action
      cidr_block = lookup(ingress.value, "cidr_block", null)
      from_port  = lookup(ingress.value, "from_port", null)
      to_port    = lookup(ingress.value, "to_port", null)
    }
  }

  dynamic "egress" {
    for_each = var.default_network_acl_egress
    content {
      rule_no    = egress.value.rule_number
      protocol   = egress.value.protocol
      action     = egress.value.rule_action
      cidr_block = lookup(egress.value, "cidr_block", null)
      from_port  = lookup(egress.value, "from_port", null)
      to_port    = lookup(egress.value, "to_port", null)
    }
  }

  tags = local.default_network_acl_tags

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

################################################################################
# Public Network ACL
################################################################################

resource "aws_network_acl" "public" {
  count = local.create_public_network_acl ? 1 : 0

  vpc_id     = aws_vpc.this[0].id
  subnet_ids = [for subnet in aws_subnet.public : subnet.id]

  tags = merge(
    {
      Name = "${local.region_prefix}-nacl-${var.public_subnet_suffix}-${var.account_name}-${var.project_name}"
      Type = "public"
    },
    local.common_tags,
    var.public_acl_tags
  )
}

resource "aws_network_acl_rule" "public_inbound" {
  for_each = local.create_public_network_acl ? {
    for rule in var.public_inbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.public[0].id

  egress      = false
  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  protocol    = each.value.protocol
  cidr_block  = lookup(each.value, "cidr_block", null)
  from_port   = lookup(each.value, "from_port", null)
  to_port     = lookup(each.value, "to_port", null)
  icmp_type   = lookup(each.value, "icmp_type", null)
  icmp_code   = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl_rule" "public_outbound" {
  for_each = local.create_public_network_acl ? {
    for rule in var.public_outbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.public[0].id

  egress      = true
  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  protocol    = each.value.protocol
  cidr_block  = lookup(each.value, "cidr_block", null)
  from_port   = lookup(each.value, "from_port", null)
  to_port     = lookup(each.value, "to_port", null)
  icmp_type   = lookup(each.value, "icmp_type", null)
  icmp_code   = lookup(each.value, "icmp_code", null)
}

################################################################################
# Private Network ACL
################################################################################

resource "aws_network_acl" "private" {
  count = local.create_private_network_acl ? 1 : 0

  vpc_id     = aws_vpc.this[0].id
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  tags = merge(
    {
      Name = "${local.region_prefix}-nacl-${var.private_subnet_suffix}-${var.account_name}-${var.project_name}"
      Type = "private"
    },
    local.common_tags,
    var.private_acl_tags
  )
}

resource "aws_network_acl_rule" "private_inbound" {
  for_each = local.create_private_network_acl ? {
    for rule in var.private_inbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.private[0].id

  egress      = false
  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  protocol    = each.value.protocol
  cidr_block  = lookup(each.value, "cidr_block", null)
  from_port   = lookup(each.value, "from_port", null)
  to_port     = lookup(each.value, "to_port", null)
  icmp_type   = lookup(each.value, "icmp_type", null)
  icmp_code   = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl_rule" "private_outbound" {
  for_each = local.create_private_network_acl ? {
    for rule in var.private_outbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.private[0].id

  egress      = true
  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  protocol    = each.value.protocol
  cidr_block  = lookup(each.value, "cidr_block", null)
  from_port   = lookup(each.value, "from_port", null)
  to_port     = lookup(each.value, "to_port", null)
  icmp_type   = lookup(each.value, "icmp_type", null)
  icmp_code   = lookup(each.value, "icmp_code", null)
}

################################################################################
# Database Network ACL
################################################################################

resource "aws_network_acl" "database" {
  count = local.create_database_network_acl ? 1 : 0

  vpc_id     = aws_vpc.this[0].id
  subnet_ids = [for subnet in aws_subnet.database : subnet.id]

  tags = merge(
    {
      Name = "${local.region_prefix}-nacl-${var.database_subnet_suffix}-${var.account_name}-${var.project_name}"
      Type = "database"
    },
    local.common_tags,
    var.database_acl_tags
  )
}

resource "aws_network_acl_rule" "database_inbound" {
  for_each = local.create_database_network_acl ? {
    for rule in var.database_inbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.database[0].id

  egress      = false
  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  protocol    = each.value.protocol
  cidr_block  = lookup(each.value, "cidr_block", null)
  from_port   = lookup(each.value, "from_port", null)
  to_port     = lookup(each.value, "to_port", null)
  icmp_type   = lookup(each.value, "icmp_type", null)
  icmp_code   = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl_rule" "database_outbound" {
  for_each = local.create_database_network_acl ? {
    for rule in var.database_outbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.database[0].id

  egress      = true
  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  protocol    = each.value.protocol
  cidr_block  = lookup(each.value, "cidr_block", null)
  from_port   = lookup(each.value, "from_port", null)
  to_port     = lookup(each.value, "to_port", null)
  icmp_type   = lookup(each.value, "icmp_type", null)
  icmp_code   = lookup(each.value, "icmp_code", null)
}

################################################################################
# Elasticache Network ACL
################################################################################

resource "aws_network_acl" "elasticache" {
  count = local.create_elasticache_network_acl ? 1 : 0

  vpc_id     = aws_vpc.this[0].id
  subnet_ids = [for subnet in aws_subnet.elasticache : subnet.id]

  tags = merge(
    {
      Name = "${local.region_prefix}-nacl-${var.elasticache_subnet_suffix}-${var.account_name}-${var.project_name}"
      Type = "elasticache"
    },
    local.common_tags,
    var.elasticache_acl_tags
  )
}

resource "aws_network_acl_rule" "elasticache_inbound" {
  for_each = local.create_elasticache_network_acl ? {
    for rule in var.elasticache_inbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.elasticache[0].id

  egress      = false
  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  protocol    = each.value.protocol
  cidr_block  = lookup(each.value, "cidr_block", null)
  from_port   = lookup(each.value, "from_port", null)
  to_port     = lookup(each.value, "to_port", null)
  icmp_type   = lookup(each.value, "icmp_type", null)
  icmp_code   = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl_rule" "elasticache_outbound" {
  for_each = local.create_elasticache_network_acl ? {
    for rule in var.elasticache_outbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.elasticache[0].id

  egress      = true
  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  protocol    = each.value.protocol
  cidr_block  = lookup(each.value, "cidr_block", null)
  from_port   = lookup(each.value, "from_port", null)
  to_port     = lookup(each.value, "to_port", null)
  icmp_type   = lookup(each.value, "icmp_type", null)
  icmp_code   = lookup(each.value, "icmp_code", null)
}

################################################################################
# Redshift Network ACL
################################################################################

resource "aws_network_acl" "redshift" {
  count = local.create_redshift_network_acl ? 1 : 0

  vpc_id     = aws_vpc.this[0].id
  subnet_ids = [for subnet in aws_subnet.redshift : subnet.id]

  tags = merge(
    {
      Name = "${local.region_prefix}-nacl-${var.redshift_subnet_suffix}-${var.account_name}-${var.project_name}"
      Type = "redshift"
    },
    local.common_tags,
    var.redshift_acl_tags
  )
}

resource "aws_network_acl_rule" "redshift_inbound" {
  for_each = local.create_redshift_network_acl ? {
    for rule in var.redshift_inbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.redshift[0].id

  egress      = false
  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  protocol    = each.value.protocol
  cidr_block  = lookup(each.value, "cidr_block", null)
  from_port   = lookup(each.value, "from_port", null)
  to_port     = lookup(each.value, "to_port", null)
  icmp_type   = lookup(each.value, "icmp_type", null)
  icmp_code   = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl_rule" "redshift_outbound" {
  for_each = local.create_redshift_network_acl ? {
    for rule in var.redshift_outbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.redshift[0].id

  egress      = true
  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  protocol    = each.value.protocol
  cidr_block  = lookup(each.value, "cidr_block", null)
  from_port   = lookup(each.value, "from_port", null)
  to_port     = lookup(each.value, "to_port", null)
  icmp_type   = lookup(each.value, "icmp_type", null)
  icmp_code   = lookup(each.value, "icmp_code", null)
}

################################################################################
# Intra Network ACL
################################################################################

resource "aws_network_acl" "intra" {
  count = local.create_intra_network_acl ? 1 : 0

  vpc_id     = aws_vpc.this[0].id
  subnet_ids = [for subnet in aws_subnet.intra : subnet.id]

  tags = merge(
    {
      Name = "${local.region_prefix}-nacl-${var.intra_subnet_suffix}-${var.account_name}-${var.project_name}"
      Type = "intra"
    },
    local.common_tags,
    var.intra_acl_tags
  )
}

resource "aws_network_acl_rule" "intra_inbound" {
  for_each = local.create_intra_network_acl ? {
    for rule in var.intra_inbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.intra[0].id

  egress      = false
  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  protocol    = each.value.protocol
  cidr_block  = lookup(each.value, "cidr_block", null)
  from_port   = lookup(each.value, "from_port", null)
  to_port     = lookup(each.value, "to_port", null)
  icmp_type   = lookup(each.value, "icmp_type", null)
  icmp_code   = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl_rule" "intra_outbound" {
  for_each = local.create_intra_network_acl ? {
    for rule in var.intra_outbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.intra[0].id

  egress      = true
  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  protocol    = each.value.protocol
  cidr_block  = lookup(each.value, "cidr_block", null)
  from_port   = lookup(each.value, "from_port", null)
  to_port     = lookup(each.value, "to_port", null)
  icmp_type   = lookup(each.value, "icmp_type", null)
  icmp_code   = lookup(each.value, "icmp_code", null)
}
