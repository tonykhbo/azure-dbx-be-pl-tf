# =====================================================================
# Databricks Workspace Outputs
# =====================================================================

output "workspace_id" {
  description = "Azure resource ID of the Databricks workspace"
  value       = module.databricks_workspace.workspace_id
}

output "workspace_url" {
  description = "URL of the Databricks workspace"
  value       = module.databricks_workspace.workspace_url
}

output "workspace_resource_id" {
  description = "Databricks workspace ID (for Unity Catalog)"
  value       = module.databricks_workspace.workspace_resource_id
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.databricks_workspace.resource_group_name
}

# =====================================================================
# Unity Catalog Outputs
# =====================================================================

output "metastore_id" {
  description = "ID of the Unity Catalog metastore"
  value       = module.unity_catalog.metastore_id
}

output "metastore_name" {
  description = "Name of the Unity Catalog metastore"
  value       = module.unity_catalog.metastore_name
}

output "metastore_storage_account_name" {
  description = "Name of the metastore storage account"
  value       = module.unity_catalog.metastore_storage_account_name
}

output "access_connector_id" {
  description = "Azure resource ID of the Databricks Access Connector"
  value       = module.unity_catalog.access_connector_id
}

# =====================================================================
# NCC Outputs
# =====================================================================

output "ncc_id" {
  description = "ID of the Network Connectivity Config"
  value       = var.enable_ncc ? module.ncc_storage[0].ncc_id : null
}

output "ncc_name" {
  description = "Name of the Network Connectivity Config"
  value       = var.enable_ncc ? module.ncc_storage[0].ncc_name : null
}

output "ncc_private_endpoint_rules" {
  description = "Map of NCC private endpoint rules created"
  value       = var.enable_ncc ? module.ncc_storage[0].private_endpoint_rules : {}
}
