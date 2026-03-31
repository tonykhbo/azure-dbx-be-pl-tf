variable "prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "suffix" {
  description = "Random suffix for resource naming"
  type        = string
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
}

variable "cidr" {
  description = "CIDR block for the virtual network"
  type        = string
}

variable "email" {
  description = "Owner email for resource tagging"
  type        = string
}

variable "remove_date" {
  description = "Date when resources should be removed"
  type        = string
}

variable "description" {
  description = "Description for resource tagging"
  type        = string
}

variable "private_subnet_endpoints" {
  description = "Service endpoints for the private subnet"
  type        = list(string)
  default     = []
}
