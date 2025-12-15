module "vpc" {
  source = "../../vpc"

  # Naming
  account_name = var.account_name
  project_name = var.project_name

  # VPC Configuration
  vpc_cidr_block = var.vpc_cidr_block

  # Availability Zones (short format - region auto-detected)
  azs = var.azs

  # Subnets
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  # Create database subnet group
  create_database_subnet_group = true

  # Internet Gateway
  create_igw = true

  # NAT Gateway - One per AZ for High Availability
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  # DNS
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tags
  tags = var.tags

  vpc_tags = {
    Name = "${var.account_name}-${var.project_name}-vpc"
  }

  public_subnet_tags = {
    Tier = "public"
  }

  private_subnet_tags = {
    Tier = "private"
  }

  database_subnet_tags = {
    Tier = "database"
  }
}
