output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_network_acl_id" {
  value = module.vpc.public_network_acl_id
}

output "private_network_acl_id" {
  value = module.vpc.private_network_acl_id
}

output "database_network_acl_id" {
  value = module.vpc.database_network_acl_id
}
