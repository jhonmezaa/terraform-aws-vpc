################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  count = local.create_igw ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = local.igw_tags
}

################################################################################
# Egress-only Internet Gateway (for IPv6)
# Allows outbound IPv6 traffic but blocks inbound IPv6 traffic
################################################################################

resource "aws_egress_only_internet_gateway" "this" {
  count = local.create_egress_only_igw ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    {
      Name = local.eigw_name
    },
    local.common_tags
  )
}
