variable "account_name" {
  description = "Account name for resource naming"
  type        = string
  default     = "staging"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "app"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.1.0.0/16"
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
    "10.1.1.0/24", # AZ-a
    "10.1.2.0/24", # AZ-b
    "10.1.3.0/24", # AZ-c
  ]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default = [
    "10.1.11.0/24", # AZ-a
    "10.1.12.0/24", # AZ-b
    "10.1.13.0/24", # AZ-c
  ]
}

variable "database_subnets" {
  description = "Database subnet CIDR blocks"
  type        = list(string)
  default = [
    "10.1.21.0/24", # AZ-a
    "10.1.22.0/24", # AZ-b
    "10.1.23.0/24", # AZ-c
  ]
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "staging"
    ManagedBy   = "terraform"
    Example     = "vpc-with-nat-gateway"
  }
}
