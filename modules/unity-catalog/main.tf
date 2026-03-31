terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    databricks = {
      source                = "databricks/databricks"
      configuration_aliases = [databricks.account]
    }
  }
}

# Databricks Access Connector (Managed Identity)
resource "azurerm_databricks_access_connector" "unity" {
  name                = "${var.prefix}-${var.suffix}-mi"
  resource_group_name = var.resource_group_name
  location            = var.location

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Unity Catalog Metastore Storage Account
resource "azurerm_storage_account" "metastore" {
  name                     = "${var.prefix}${var.suffix}ucms"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  is_hns_enabled           = true

  tags = var.tags
}

resource "azurerm_storage_container" "metastore" {
  name                  = "${var.prefix}-${var.suffix}-metastore"
  storage_account_name  = azurerm_storage_account.metastore.name
  container_access_type = "private"
}

# Grant Access Connector permissions to the metastore storage
resource "azurerm_role_assignment" "metastore" {
  scope                = azurerm_storage_account.metastore.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.unity.identity[0].principal_id
}

# Unity Catalog Metastore
resource "databricks_metastore" "this" {
  provider     = databricks.account
  name         = "${var.suffix}-${var.metastore_name}"
  storage_root = format("abfss://%s@%s.dfs.core.windows.net/",
    azurerm_storage_container.metastore.name,
    azurerm_storage_account.metastore.name
  )
  force_destroy = true
  region        = var.location
}

# Metastore Data Access Configuration
resource "databricks_metastore_data_access" "this" {
  provider     = databricks.account
  metastore_id = databricks_metastore.this.id
  name         = "${var.suffix}-${var.metastore_name}-dac"

  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.unity.id
  }

  is_default = true
}

# Assign Metastore to Workspace
resource "databricks_metastore_assignment" "this" {
  provider             = databricks.account
  workspace_id         = var.workspace_id
  metastore_id         = databricks_metastore.this.id
  default_catalog_name = "${var.suffix}_default_catalog"
}
