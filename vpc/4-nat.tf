################################################################################
# NAT Gateway
################################################################################

# Elastic IPs for NAT Gateway (only if not reusing existing IPs)
resource "aws_eip" "nat" {
  for_each = local.enable_nat_gateway && !local.reuse_nat_ips ? toset([
    for i in range(local.nat_gateway_count) : tostring(i)
  ]) : toset([])

  domain = "vpc"

  tags = merge(
    local.common_tags,
    var.nat_eip_tags,
    {
      Name      = local.eip_names[tonumber(each.key)]
      ManagedBy = "Terraform"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

# NAT Gateways
# Strategy 1: No NAT (enable_nat_gateway = false) → 0 NAT Gateways
# Strategy 2: Single NAT (single_nat_gateway = true) → 1 NAT Gateway
# Strategy 3: One per AZ (one_nat_gateway_per_az = true) → 1 NAT per AZ
# Strategy 4: One per subnet (default) → 1 NAT per private subnet
resource "aws_nat_gateway" "this" {
  for_each = local.enable_nat_gateway ? toset([
    for i in range(local.nat_gateway_count) : tostring(i)
  ]) : toset([])

  # Use external EIP if reusing, otherwise use newly created EIP
  allocation_id = local.reuse_nat_ips ? element(
    var.external_nat_ip_ids,
    tonumber(each.key)
  ) : aws_eip.nat[each.key].id

  # Determine which public subnet to use based on strategy
  # Index by numeric key (map iteration order is lexical: "10" < "2")
  subnet_id = aws_subnet.public[tostring(
    local.nat_gateway_public_subnet_indices[tonumber(each.key)] % local.len_public_subnets
  )].id

  tags = merge(
    local.common_tags,
    var.nat_gateway_tags,
    {
      Name      = local.nat_gateway_names[tonumber(each.key)]
      ManagedBy = "Terraform"
    }
  )

  depends_on = [aws_internet_gateway.this]
}
