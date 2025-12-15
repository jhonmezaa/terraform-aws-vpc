output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "elasticache_subnets" {
  value = module.vpc.elasticache_subnets
}

output "redshift_subnets" {
  value = module.vpc.redshift_subnets
}

output "intra_subnets" {
  value = module.vpc.intra_subnets
}

output "database_subnet_group_name" {
  value = module.vpc.database_subnet_group_name
}

output "elasticache_subnet_group_name" {
  value = module.vpc.elasticache_subnet_group_name
}

output "redshift_subnet_group_name" {
  value = module.vpc.redshift_subnet_group_name
}

output "nat_ids" {
  value = module.vpc.nat_ids
}

output "nat_public_ips" {
  value = module.vpc.nat_public_ips
}

output "vpc_flow_log_id" {
  value = module.vpc.vpc_flow_log_id
}

output "vpc_endpoint_s3_id" {
  value = module.vpc.vpc_endpoint_s3_id
}

output "vpc_endpoint_dynamodb_id" {
  value = module.vpc.vpc_endpoint_dynamodb_id
}
