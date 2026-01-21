################################################################################
# VPC Endpoints
################################################################################

################################################################################
# Gateway Endpoints (S3, DynamoDB)
################################################################################

# S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3" {
  count = local.create_vpc_endpoints && var.enable_s3_endpoint ? 1 : 0

  vpc_id            = aws_vpc.this[0].id
  service_name      = "com.amazonaws.${data.aws_region.current.id}.s3"
  vpc_endpoint_type = "Gateway"

  # Associate with route tables
  route_table_ids = compact(concat(
    [for rt in aws_route_table.public : rt.id],
    [for rt in aws_route_table.private : rt.id],
    var.create_database_subnet_route_table ? [for rt in aws_route_table.database : rt.id] : [],
    var.create_elasticache_subnet_route_table ? [for rt in aws_route_table.elasticache : rt.id] : [],
    var.create_redshift_subnet_route_table ? [for rt in aws_route_table.redshift : rt.id] : [],
    [for rt in aws_route_table.intra : rt.id]
  ))

  tags = merge(
    {
      Name = "${local.region_prefix}-vpce-s3-${var.account_name}-${var.project_name}"
    },
    local.common_tags,
    var.s3_endpoint_tags
  )
}

# DynamoDB Gateway Endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  count = local.create_vpc_endpoints && var.enable_dynamodb_endpoint ? 1 : 0

  vpc_id            = aws_vpc.this[0].id
  service_name      = "com.amazonaws.${data.aws_region.current.id}.dynamodb"
  vpc_endpoint_type = "Gateway"

  # Associate with route tables
  route_table_ids = compact(concat(
    [for rt in aws_route_table.public : rt.id],
    [for rt in aws_route_table.private : rt.id],
    var.create_database_subnet_route_table ? [for rt in aws_route_table.database : rt.id] : [],
    var.create_elasticache_subnet_route_table ? [for rt in aws_route_table.elasticache : rt.id] : [],
    var.create_redshift_subnet_route_table ? [for rt in aws_route_table.redshift : rt.id] : [],
    [for rt in aws_route_table.intra : rt.id]
  ))

  tags = merge(
    {
      Name = "${local.region_prefix}-vpce-dynamodb-${var.account_name}-${var.project_name}"
    },
    local.common_tags,
    var.dynamodb_endpoint_tags
  )
}
