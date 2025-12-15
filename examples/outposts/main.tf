module "vpc" {
  source = "../../vpc"

  account_name = "prod"
  project_name = "outpost"

  vpc_cidr_block = "10.9.0.0/16"
  azs            = ["a"]

  # Standard cloud subnets
  public_subnets  = ["10.9.1.0/24"]
  private_subnets = ["10.9.11.0/24"]

  # Outpost subnet (requires Outpost ARN)
  # outpost_subnets = ["10.9.100.0/24"]
  # outpost_arn     = "arn:aws:outposts:us-east-1:123456789012:outpost/op-1234567890abcdef0"

  create_igw         = true
  enable_nat_gateway = true

  tags = {
    Environment = "production"
    Outposts    = "enabled"
  }
}
