variable "prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "suffix" {
  description = "Random suffix for resource naming"
  type        = string
}

variable "location" {
  description = "Azure region for the NCC"
  type        = string
}

variable "workspace_id" {
  description = "Databricks workspace ID to bind NCC to"
  type        = string
}

variable "storage_accounts" {
  description = "Map of storage accounts to create private endpoint rules for"
  type = map(object({
    resource_id = string
    name        = string
  }))
}

variable "storage_group_id" {
  description = "Storage endpoint type (blob or dfs)"
  type        = string
  default     = "dfs"
}
