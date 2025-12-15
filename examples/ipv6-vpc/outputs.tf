output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_ipv6_cidr_block" {
  description = "IPv6 CIDR block"
  value       = module.vpc.vpc_ipv6_cidr_block
}

output "egress_only_igw_id" {
  description = "Egress-only Internet Gateway ID"
  value       = module.vpc.egress_only_igw_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}
