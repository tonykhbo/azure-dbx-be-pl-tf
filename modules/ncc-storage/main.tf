terraform {
  required_providers {
    databricks = {
      source                = "databricks/databricks"
      configuration_aliases = [databricks.account]
    }
    time = {
      source = "hashicorp/time"
    }
  }
}

# Create Network Connectivity Config at account level
resource "databricks_mws_network_connectivity_config" "this" {
  provider = databricks.account
  name     = "${var.prefix}-ncc-${var.suffix}"
  region   = var.location
}

# Wait for NCC to propagate
resource "time_sleep" "wait_for_ncc" {
  depends_on      = [databricks_mws_network_connectivity_config.this]
  create_duration = "10s"
}

# Bind NCC to the workspace
resource "databricks_mws_ncc_binding" "this" {
  provider                       = databricks.account
  network_connectivity_config_id = databricks_mws_network_connectivity_config.this.network_connectivity_config_id
  workspace_id                   = var.workspace_id
  depends_on                     = [time_sleep.wait_for_ncc]
}

# Create private endpoint rule for each storage account
resource "databricks_mws_ncc_private_endpoint_rule" "storage" {
  for_each = var.storage_accounts

  provider                       = databricks.account
  network_connectivity_config_id = databricks_mws_network_connectivity_config.this.network_connectivity_config_id
  resource_id                    = each.value.resource_id
  group_id                       = var.storage_group_id

  depends_on = [databricks_mws_network_connectivity_config.this]
}
