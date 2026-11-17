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
      rule_no         = ingress.value.rule_number
      protocol        = ingress.value.protocol
      action          = ingress.value.rule_action
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      from_port       = lookup(ingress.value, "from_port", null)
      to_port         = lookup(ingress.value, "to_port", null)
    }
  }

  dynamic "egress" {
    for_each = var.default_network_acl_egress
    content {
      rule_no         = egress.value.rule_number
      protocol        = egress.value.protocol
      action          = egress.value.rule_action
      cidr_block      = lookup(egress.value, "cidr_block", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      icmp_code       = lookup(egress.value, "icmp_code", null)
      from_port       = lookup(egress.value, "from_port", null)
      to_port         = lookup(egress.value, "to_port", null)
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
    local.common_tags,
    {
      Type = "public"
    },
    var.public_acl_tags,
    {
      Name      = "${local.name_prefix}nacl-${var.public_subnet_suffix}-${var.account_name}-${var.project_name}"
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_network_acl_rule" "public_inbound" {
  for_each = local.create_public_network_acl ? {
    for rule in var.public_inbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.public[0].id

  egress          = false
  rule_number     = each.value.rule_number
  rule_action     = each.value.rule_action
  protocol        = each.value.protocol
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl_rule" "public_outbound" {
  for_each = local.create_public_network_acl ? {
    for rule in var.public_outbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.public[0].id

  egress          = true
  rule_number     = each.value.rule_number
  rule_action     = each.value.rule_action
  protocol        = each.value.protocol
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

################################################################################
# Private Network ACL
################################################################################

resource "aws_network_acl" "private" {
  count = local.create_private_network_acl ? 1 : 0

  vpc_id     = aws_vpc.this[0].id
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  tags = merge(
    local.common_tags,
    {
      Type = "private"
    },
    var.private_acl_tags,
    {
      Name      = "${local.name_prefix}nacl-${var.private_subnet_suffix}-${var.account_name}-${var.project_name}"
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_network_acl_rule" "private_inbound" {
  for_each = local.create_private_network_acl ? {
    for rule in var.private_inbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.private[0].id

  egress          = false
  rule_number     = each.value.rule_number
  rule_action     = each.value.rule_action
  protocol        = each.value.protocol
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl_rule" "private_outbound" {
  for_each = local.create_private_network_acl ? {
    for rule in var.private_outbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.private[0].id

  egress          = true
  rule_number     = each.value.rule_number
  rule_action     = each.value.rule_action
  protocol        = each.value.protocol
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

################################################################################
# Database Network ACL
################################################################################

resource "aws_network_acl" "database" {
  count = local.create_database_network_acl ? 1 : 0

  vpc_id     = aws_vpc.this[0].id
  subnet_ids = [for subnet in aws_subnet.database : subnet.id]

  tags = merge(
    local.common_tags,
    {
      Type = "database"
    },
    var.database_acl_tags,
    {
      Name      = "${local.name_prefix}nacl-${var.database_subnet_suffix}-${var.account_name}-${var.project_name}"
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_network_acl_rule" "database_inbound" {
  for_each = local.create_database_network_acl ? {
    for rule in var.database_inbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.database[0].id

  egress          = false
  rule_number     = each.value.rule_number
  rule_action     = each.value.rule_action
  protocol        = each.value.protocol
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl_rule" "database_outbound" {
  for_each = local.create_database_network_acl ? {
    for rule in var.database_outbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.database[0].id

  egress          = true
  rule_number     = each.value.rule_number
  rule_action     = each.value.rule_action
  protocol        = each.value.protocol
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

################################################################################
# Elasticache Network ACL
################################################################################

resource "aws_network_acl" "elasticache" {
  count = local.create_elasticache_network_acl ? 1 : 0

  vpc_id     = aws_vpc.this[0].id
  subnet_ids = [for subnet in aws_subnet.elasticache : subnet.id]

  tags = merge(
    local.common_tags,
    {
      Type = "elasticache"
    },
    var.elasticache_acl_tags,
    {
      Name      = "${local.name_prefix}nacl-${var.elasticache_subnet_suffix}-${var.account_name}-${var.project_name}"
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_network_acl_rule" "elasticache_inbound" {
  for_each = local.create_elasticache_network_acl ? {
    for rule in var.elasticache_inbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.elasticache[0].id

  egress          = false
  rule_number     = each.value.rule_number
  rule_action     = each.value.rule_action
  protocol        = each.value.protocol
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl_rule" "elasticache_outbound" {
  for_each = local.create_elasticache_network_acl ? {
    for rule in var.elasticache_outbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.elasticache[0].id

  egress          = true
  rule_number     = each.value.rule_number
  rule_action     = each.value.rule_action
  protocol        = each.value.protocol
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

################################################################################
# Redshift Network ACL
################################################################################

resource "aws_network_acl" "redshift" {
  count = local.create_redshift_network_acl ? 1 : 0

  vpc_id     = aws_vpc.this[0].id
  subnet_ids = [for subnet in aws_subnet.redshift : subnet.id]

  tags = merge(
    local.common_tags,
    {
      Type = "redshift"
    },
    var.redshift_acl_tags,
    {
      Name      = "${local.name_prefix}nacl-${var.redshift_subnet_suffix}-${var.account_name}-${var.project_name}"
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_network_acl_rule" "redshift_inbound" {
  for_each = local.create_redshift_network_acl ? {
    for rule in var.redshift_inbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.redshift[0].id

  egress          = false
  rule_number     = each.value.rule_number
  rule_action     = each.value.rule_action
  protocol        = each.value.protocol
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl_rule" "redshift_outbound" {
  for_each = local.create_redshift_network_acl ? {
    for rule in var.redshift_outbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.redshift[0].id

  egress          = true
  rule_number     = each.value.rule_number
  rule_action     = each.value.rule_action
  protocol        = each.value.protocol
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

################################################################################
# Intra Network ACL
################################################################################

resource "aws_network_acl" "intra" {
  count = local.create_intra_network_acl ? 1 : 0

  vpc_id     = aws_vpc.this[0].id
  subnet_ids = [for subnet in aws_subnet.intra : subnet.id]

  tags = merge(
    local.common_tags,
    {
      Type = "intra"
    },
    var.intra_acl_tags,
    {
      Name      = "${local.name_prefix}nacl-${var.intra_subnet_suffix}-${var.account_name}-${var.project_name}"
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_network_acl_rule" "intra_inbound" {
  for_each = local.create_intra_network_acl ? {
    for rule in var.intra_inbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.intra[0].id

  egress          = false
  rule_number     = each.value.rule_number
  rule_action     = each.value.rule_action
  protocol        = each.value.protocol
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl_rule" "intra_outbound" {
  for_each = local.create_intra_network_acl ? {
    for rule in var.intra_outbound_acl_rules : "${rule.rule_number}" => rule
  } : {}

  network_acl_id = aws_network_acl.intra[0].id

  egress          = true
  rule_number     = each.value.rule_number
  rule_action     = each.value.rule_action
  protocol        = each.value.protocol
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

################################################################################
# Default Security Group
# Adopts the VPC default security group. With empty rule lists every rule is
# removed from it, so nothing can accidentally rely on it (CIS 5.4).
################################################################################

resource "aws_default_security_group" "this" {
  count = local.create_vpc && var.manage_default_security_group ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  dynamic "ingress" {
    for_each = var.default_security_group_ingress
    content {
      self             = lookup(ingress.value, "self", null)
      cidr_blocks      = compact(split(",", lookup(ingress.value, "cidr_blocks", "")))
      ipv6_cidr_blocks = compact(split(",", lookup(ingress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(ingress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(ingress.value, "security_groups", "")))
      description      = lookup(ingress.value, "description", null)
      from_port        = lookup(ingress.value, "from_port", 0)
      to_port          = lookup(ingress.value, "to_port", 0)
      protocol         = lookup(ingress.value, "protocol", "-1")
    }
  }

  dynamic "egress" {
    for_each = var.default_security_group_egress
    content {
      self             = lookup(egress.value, "self", null)
      cidr_blocks      = compact(split(",", lookup(egress.value, "cidr_blocks", "")))
      ipv6_cidr_blocks = compact(split(",", lookup(egress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(egress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(egress.value, "security_groups", "")))
      description      = lookup(egress.value, "description", null)
      from_port        = lookup(egress.value, "from_port", 0)
      to_port          = lookup(egress.value, "to_port", 0)
      protocol         = lookup(egress.value, "protocol", "-1")
    }
  }

  tags = merge(
    local.common_tags,
    var.default_security_group_tags,
    {
      Name      = local.default_security_group_name
      ManagedBy = "Terraform"
    }
  )
}
