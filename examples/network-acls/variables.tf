# Network ACLs Example Variables
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
  default     = "secure"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.5.0.0/16"
}

variable "azs" {
  description = "Availability zones (short format)"
  type        = list(string)
  default     = ["a", "b", "c"]
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default = [
    "10.5.1.0/24",
    "10.5.2.0/24",
    "10.5.3.0/24",
  ]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default = [
    "10.5.11.0/24",
    "10.5.12.0/24",
    "10.5.13.0/24",
  ]
}

variable "database_subnets" {
  description = "Database subnet CIDR blocks"
  type        = list(string)
  default = [
    "10.5.21.0/24",
    "10.5.22.0/24",
    "10.5.23.0/24",
  ]
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "production"
    Security    = "enhanced"
  }
}
