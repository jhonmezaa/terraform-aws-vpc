################################################################################
# VPN Gateway
################################################################################

resource "aws_vpn_gateway" "this" {
  count = local.create_vpn_gateway && var.vpn_gateway_id == null ? 1 : 0

  vpc_id            = aws_vpc.this[0].id
  amazon_side_asn   = var.amazon_side_asn
  availability_zone = var.vpn_gateway_az

  tags = local.vpn_gateway_tags
}

# Attach existing VPN Gateway to VPC
resource "aws_vpn_gateway_attachment" "this" {
  count = var.enable_vpn_gateway && var.vpn_gateway_id != null ? 1 : 0

  vpc_id         = aws_vpc.this[0].id
  vpn_gateway_id = var.vpn_gateway_id
}
