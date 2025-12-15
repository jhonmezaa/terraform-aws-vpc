module "vpc" {
  source = "../../vpc"

  # Naming
  account_name = var.account_name
  project_name = var.project_name

  # VPC CIDR
  vpc_cidr_block = var.vpc_cidr_block

  # Availability Zones (short format - region auto-detected)
  azs = var.azs

  # Subnets
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  # Internet Gateway
  create_igw = true

  # NAT Gateway - Disabled for cost savings
  enable_nat_gateway = false

  # DNS
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tags
  tags = var.tags

  vpc_tags = {
    Name = "${var.account_name}-${var.project_name}-vpc"
  }
}
