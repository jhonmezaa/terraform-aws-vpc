# AWS Outposts Example Variables
# These variables are optional - defaults are provided in main.tf
# Copy terraform.tfvars.example to terraform.tfvars to customize

variable "account_name" {
  description = "Account name for resource naming"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "outpost"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.9.0.0/16"
}

variable "azs" {
  description = "Availability zones (must match Outpost AZ)"
  type        = list(string)
  default     = ["a"]
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks in cloud region"
  type        = list(string)
  default     = ["10.9.1.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks in cloud region"
  type        = list(string)
  default     = ["10.9.11.0/24"]
}

variable "outpost_subnets" {
  description = "Outpost subnet CIDR blocks (uncomment and configure for actual Outpost deployment)"
  type        = list(string)
  default     = []
  # default = ["10.9.100.0/24"]
}

variable "outpost_arn" {
  description = "ARN of AWS Outpost (required for Outpost subnet creation)"
  type        = string
  default     = null
  # default = "arn:aws:outposts:us-east-1:123456789012:outpost/op-1234567890abcdef0"

  validation {
    condition = (
      var.outpost_arn == null ||
      can(regex("^arn:aws:outposts:[a-z0-9-]+:[0-9]+:outpost/op-[a-f0-9]+$", var.outpost_arn))
    )
    error_message = "Outpost ARN must be valid format: arn:aws:outposts:region:account:outpost/op-id"
  }
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "production"
    Outposts    = "enabled"
  }
}
