################################################################################
# Data Sources
################################################################################

# Current AWS region
data "aws_region" "current" {}

# Available availability zones in current region
data "aws_availability_zones" "available" {
  state = "available"

  # Exclude local zones if needed
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Current AWS account information
data "aws_caller_identity" "current" {}

# Current AWS partition (aws, aws-cn, aws-us-gov)
data "aws_partition" "current" {}
