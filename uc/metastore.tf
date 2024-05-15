resource "databricks_metastore" "this" {
  provider      = databricks.accounts
  name          = var.uc_metastore_name
  region        = data.azurerm_resource_group.this.location
  force_destroy = true
}

resource "databricks_metastore_assignment" "this" {
  provider             = databricks.accounts
  workspace_id         = local.databricks_workspace_id
  metastore_id         = databricks_metastore.this.id
  default_catalog_name = "default_catalog"
}