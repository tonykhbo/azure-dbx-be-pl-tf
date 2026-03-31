output "metastore_id" {
  description = "ID of the Unity Catalog metastore"
  value       = databricks_metastore.this.id
}

output "metastore_name" {
  description = "Name of the Unity Catalog metastore"
  value       = databricks_metastore.this.name
}

output "metastore_storage_account_id" {
  description = "Azure resource ID of the metastore storage account"
  value       = azurerm_storage_account.metastore.id
}

output "metastore_storage_account_name" {
  description = "Name of the metastore storage account"
  value       = azurerm_storage_account.metastore.name
}

output "access_connector_id" {
  description = "Azure resource ID of the Databricks Access Connector"
  value       = azurerm_databricks_access_connector.unity.id
}

output "access_connector_principal_id" {
  description = "Principal ID of the Access Connector managed identity"
  value       = azurerm_databricks_access_connector.unity.identity[0].principal_id
}
