# Secondary CIDRs Example Variables
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
  default     = "expanded"
}

variable "vpc_cidr_block" {
  description = "Primary CIDR block for VPC"
  type        = string
  default     = "10.6.0.0/16"
}

variable "secondary_cidr_blocks" {
  description = "Additional CIDR blocks for VPC expansion (max 5 total including primary)"
  type        = list(string)
  default = [
    "10.7.0.0/16",
    "10.8.0.0/16",
  ]

  validation {
    condition     = length(var.secondary_cidr_blocks) <= 4
    error_message = "Maximum 4 secondary CIDR blocks allowed (5 total including primary)."
  }
}

variable "azs" {
  description = "Availability zones (short format)"
  type        = list(string)
  default     = ["a", "b", "c"]
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks from primary CIDR"
  type        = list(string)
  default = [
    "10.6.1.0/24",
    "10.6.2.0/24",
    "10.6.3.0/24",
  ]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks from primary CIDR"
  type        = list(string)
  default = [
    "10.6.11.0/24",
    "10.6.12.0/24",
    "10.6.13.0/24",
  ]
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "production"
    Feature     = "secondary-cidrs"
  }
}
