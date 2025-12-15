module "vpc" {
  source = "../../vpc"

  # Naming
  account_name = var.account_name
  project_name = var.project_name

  # VPC Configuration
  vpc_cidr_block = var.vpc_cidr_block

  # Availability Zones
  azs = var.azs

  # All subnet types
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  database_subnets    = var.database_subnets
  elasticache_subnets = var.elasticache_subnets
  redshift_subnets    = var.redshift_subnets
  intra_subnets       = var.intra_subnets

  # Subnet groups
  create_database_subnet_group    = true
  create_elasticache_subnet_group = true
  create_redshift_subnet_group    = true

  # Internet Gateway
  create_igw = true

  # NAT Gateway (HA)
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  # DNS
  enable_dns_hostnames = true
  enable_dns_support   = true

  # DHCP Options
  enable_dhcp_options              = true
  dhcp_options_domain_name         = "ec2.internal"
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]

  # VPC Flow Logs
  enable_flow_log                                 = true
  flow_log_destination_type                       = "cloud-watch-logs"
  flow_log_traffic_type                           = "ALL"
  create_flow_log_cloudwatch_iam_role             = true
  flow_log_cloudwatch_log_group_retention_in_days = 7

  # VPC Endpoints
  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  # Tags
  tags = var.tags

  vpc_tags = {
    Name = "${var.account_name}-${var.project_name}-vpc"
  }

  public_subnet_tags = {
    Tier                     = "public"
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    Tier                              = "private"
    "kubernetes.io/role/internal-elb" = "1"
  }

  database_subnet_tags = {
    Tier = "database"
  }

  elasticache_subnet_tags = {
    Tier = "cache"
  }

  redshift_subnet_tags = {
    Tier = "analytics"
  }

  intra_subnet_tags = {
    Tier = "isolated"
  }
}
