variable "account_name" {
  description = "Account name for resource naming"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "ecommerce"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.2.0.0/16"
}

variable "azs" {
  description = "Availability zones (short format)"
  type        = list(string)
  default     = ["a", "b", "c"]
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.2.11.0/24", "10.2.12.0/24", "10.2.13.0/24"]
}

variable "database_subnets" {
  description = "Database subnet CIDR blocks"
  type        = list(string)
  default     = ["10.2.21.0/24", "10.2.22.0/24", "10.2.23.0/24"]
}

variable "elasticache_subnets" {
  description = "Elasticache subnet CIDR blocks"
  type        = list(string)
  default     = ["10.2.31.0/24", "10.2.32.0/24", "10.2.33.0/24"]
}

variable "redshift_subnets" {
  description = "Redshift subnet CIDR blocks"
  type        = list(string)
  default     = ["10.2.41.0/24", "10.2.42.0/24", "10.2.43.0/24"]
}

variable "intra_subnets" {
  description = "Intra subnet CIDR blocks (no internet access)"
  type        = list(string)
  default     = ["10.2.51.0/24", "10.2.52.0/24", "10.2.53.0/24"]
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "production"
    CostCenter  = "engineering"
    Terraform   = "true"
    Example     = "complete-vpc"
  }
}
