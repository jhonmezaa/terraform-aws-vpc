module "vpc" {
  source = "../../vpc"

  account_name = "prod"
  project_name = "expanded"

  # Primary CIDR
  vpc_cidr_block = "10.6.0.0/16"

  # Additional CIDR blocks for IP expansion
  secondary_cidr_blocks = [
    "10.7.0.0/16",
    "10.8.0.0/16",
  ]

  azs = ["a", "b", "c"]

  # Subnets from primary CIDR
  public_subnets  = ["10.6.1.0/24", "10.6.2.0/24", "10.6.3.0/24"]
  private_subnets = ["10.6.11.0/24", "10.6.12.0/24", "10.6.13.0/24"]

  # Additional subnets can use secondary CIDRs
  # (create manually or use additional subnet configurations)

  create_igw             = true
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "production"
    Feature     = "secondary-cidrs"
  }
}
