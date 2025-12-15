output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vgw_id" {
  description = "VPN Gateway ID"
  value       = module.vpc.vgw_id
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "database_route_table_ids" {
  value = module.vpc.database_route_table_ids
}
