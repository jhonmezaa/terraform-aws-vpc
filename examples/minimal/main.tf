module "vpc" {
  source = "../../vpc"

  # Required variables only
  account_name = var.account_name
  project_name = var.project_name

  # Public subnets (AZs auto-detected)
  public_subnets = var.public_subnets
}
