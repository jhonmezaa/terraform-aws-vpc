module "vpc" {
  source = "../../vpc"

  account_name = "prod"
  project_name = "ipv6-app"

  vpc_cidr_block = "10.3.0.0/16"
  enable_ipv6    = true

  azs = ["a", "b", "c"]

  public_subnets                                = ["10.3.1.0/24", "10.3.2.0/24", "10.3.3.0/24"]
  public_subnet_assign_ipv6_address_on_creation = true
  public_subnet_ipv6_prefixes                   = [0, 1, 2]

  private_subnets                                = ["10.3.11.0/24", "10.3.12.0/24", "10.3.13.0/24"]
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [11, 12, 13]

  create_igw             = true
  create_egress_only_igw = true

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "production"
    IPv6        = "enabled"
  }
}
