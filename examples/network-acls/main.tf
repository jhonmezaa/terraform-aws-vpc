module "vpc" {
  source = "../../vpc"

  account_name = "prod"
  project_name = "secure"

  vpc_cidr_block = "10.5.0.0/16"
  azs            = ["a", "b", "c"]

  public_subnets   = ["10.5.1.0/24", "10.5.2.0/24", "10.5.3.0/24"]
  private_subnets  = ["10.5.11.0/24", "10.5.12.0/24", "10.5.13.0/24"]
  database_subnets = ["10.5.21.0/24", "10.5.22.0/24", "10.5.23.0/24"]

  create_igw             = true
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true

  # Custom Network ACLs
  public_dedicated_network_acl   = true
  private_dedicated_network_acl  = true
  database_dedicated_network_acl = true

  # Public NACL - Allow HTTP/HTTPS
  public_inbound_acl_rules = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 110
      rule_action = "allow"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 120
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
  ]

  public_outbound_acl_rules = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]

  # Private NACL - Allow from VPC only
  private_inbound_acl_rules = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "10.5.0.0/16"
    },
  ]

  private_outbound_acl_rules = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]

  # Database NACL - PostgreSQL from private subnets only
  database_inbound_acl_rules = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_block  = "10.5.11.0/24"
    },
    {
      rule_number = 110
      rule_action = "allow"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_block  = "10.5.12.0/24"
    },
    {
      rule_number = 120
      rule_action = "allow"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_block  = "10.5.13.0/24"
    },
  ]

  database_outbound_acl_rules = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "10.5.0.0/16"
    },
  ]

  tags = {
    Environment = "production"
    Security    = "enhanced"
  }
}
