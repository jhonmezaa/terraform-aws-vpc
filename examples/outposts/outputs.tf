output "vpc_id" {
  value = module.vpc.vpc_id
}

output "outpost_subnet_ids" {
  description = "Outpost subnet IDs"
  value       = module.vpc.outpost_subnets
}
