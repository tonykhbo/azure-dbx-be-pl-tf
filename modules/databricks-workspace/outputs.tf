output "workspace_id" {
  description = "Azure resource ID of the Databricks workspace"
  value       = azurerm_databricks_workspace.this.id
}

output "workspace_url" {
  description = "URL of the Databricks workspace"
  value       = azurerm_databricks_workspace.this.workspace_url
}

output "workspace_resource_id" {
  description = "Databricks workspace ID (for Unity Catalog assignment)"
  value       = azurerm_databricks_workspace.this.workspace_id
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.this.id
}

output "location" {
  description = "Azure region where resources are deployed"
  value       = azurerm_resource_group.this.location
}
