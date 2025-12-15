module "vpc" {
  source = "../../vpc"

  account_name = "prod"
  project_name = "hybrid"

  vpc_cidr_block = "10.4.0.0/16"
  azs            = ["a", "b", "c"]

  public_subnets   = ["10.4.1.0/24", "10.4.2.0/24", "10.4.3.0/24"]
  private_subnets  = ["10.4.11.0/24", "10.4.12.0/24", "10.4.13.0/24"]
  database_subnets = ["10.4.21.0/24", "10.4.22.0/24", "10.4.23.0/24"]

  create_database_subnet_group = true

  create_igw             = true
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true

  # VPN Gateway
  enable_vpn_gateway = true
  amazon_side_asn    = 64512

  # Propagate VPN routes
  propagate_private_route_tables_vgw  = true
  propagate_database_route_tables_vgw = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "production"
    Connectivity = "hybrid"
  }
}
