# =====================================================================
# Common Variables
# =====================================================================

variable "prefix" {
  description = "Prefix for resource naming (e.g., username, environment). No special characters or spaces."
  type        = string
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
}

variable "email" {
  description = "Owner email for resource tagging"
  type        = string
}

variable "remove_date" {
  description = "Date when resources should be removed (for tagging)"
  type        = string
}

variable "description" {
  description = "Description for resource tagging"
  type        = string
  default     = "Databricks Private Link with Unity Catalog and NCC"
}

# =====================================================================
# Azure Subscription Variables
# =====================================================================

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

# =====================================================================
# Databricks Account Variables
# =====================================================================

variable "databricks_account_id" {
  description = "Databricks account console ID for account-level operations"
  type        = string
}

# =====================================================================
# Networking Variables
# =====================================================================

variable "cidr" {
  description = "CIDR block for the virtual network"
  type        = string
}

variable "private_subnet_endpoints" {
  description = "Service endpoints for the private subnet"
  type        = list(string)
  default     = []
}

# =====================================================================
# Unity Catalog Variables
# =====================================================================

variable "uc_metastore_name" {
  description = "Name for the Unity Catalog metastore"
  type        = string
}

# =====================================================================
# NCC Variables
# =====================================================================

variable "enable_ncc" {
  description = "Whether to enable Network Connectivity Config for storage"
  type        = bool
  default     = true
}

variable "storage_group_id" {
  description = "Azure Storage endpoint type: 'dfs' for ADLS Gen2, 'blob' for Blob Storage"
  type        = string
  default     = "dfs"
  validation {
    condition     = contains(["blob", "dfs"], var.storage_group_id)
    error_message = "storage_group_id must be either 'blob' or 'dfs'"
  }
}
