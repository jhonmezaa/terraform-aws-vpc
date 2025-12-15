# VPN Gateway Example Variables
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
  default     = "hybrid"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC (ensure no overlap with on-premises network)"
  type        = string
  default     = "10.4.0.0/16"
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
    "10.4.1.0/24",
    "10.4.2.0/24",
    "10.4.3.0/24",
  ]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default = [
    "10.4.11.0/24",
    "10.4.12.0/24",
    "10.4.13.0/24",
  ]
}

variable "database_subnets" {
  description = "Database subnet CIDR blocks"
  type        = list(string)
  default = [
    "10.4.21.0/24",
    "10.4.22.0/24",
    "10.4.23.0/24",
  ]
}

variable "amazon_side_asn" {
  description = "BGP ASN for AWS side of VPN connection (must differ from on-premises ASN)"
  type        = number
  default     = 64512

  validation {
    condition     = var.amazon_side_asn >= 64512 && var.amazon_side_asn <= 65534
    error_message = "ASN must be in private range: 64512-65534."
  }
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment  = "production"
    Connectivity = "hybrid"
  }
}
