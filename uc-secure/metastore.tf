resource "databricks_metastore" "this" {
  provider             = databricks.accounts
  name = "${random_string.test.result}-${var.uc_metastore_name}"
  storage_root = format("abfss://%s@%s.dfs.core.windows.net/",
    azurerm_storage_container.unity_catalog.name,
  azurerm_storage_account.unity_catalog.name)
  force_destroy = true
}

resource "databricks_metastore_data_access" "first" {
  provider             = databricks.accounts
  metastore_id = databricks_metastore.this.id
  name         = "${random_string.test.result}-${var.uc_metastore_name}"
  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.unity.id
  }

  is_default = true
}

resource "databricks_metastore_assignment" "this" {
  provider             = databricks.accounts
  workspace_id         = local.databricks_workspace_id
  metastore_id         = databricks_metastore.this.id
  default_catalog_name = "${random_string.test.result}_default_catalog"
}