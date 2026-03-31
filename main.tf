# =====================================================================
# Random String for Consistent Naming
# =====================================================================

resource "random_string" "global_suffix" {
  length  = 4
  lower   = true
  upper   = false
  special = false
}

# =====================================================================
# Azure Databricks Workspace with Private Link
# =====================================================================

module "databricks_workspace" {
  source = "./modules/databricks-workspace"

  prefix                   = var.prefix
  suffix                   = random_string.global_suffix.result
  location                 = var.location
  cidr                     = var.cidr
  email                    = var.email
  remove_date              = var.remove_date
  description              = var.description
  private_subnet_endpoints = var.private_subnet_endpoints
}

# =====================================================================
# Unity Catalog with Metastore
# =====================================================================

module "unity_catalog" {
  source = "./modules/unity-catalog"

  prefix              = var.prefix
  suffix              = random_string.global_suffix.result
  location            = module.databricks_workspace.location
  resource_group_name = module.databricks_workspace.resource_group_name
  workspace_id        = module.databricks_workspace.workspace_resource_id
  metastore_name      = var.uc_metastore_name

  tags = {
    Owner       = var.email
    RemoveAfter = var.remove_date
    Description = var.description
  }

  depends_on = [module.databricks_workspace]

  providers = {
    databricks.account = databricks.account
  }
}

# =====================================================================
# Network Connectivity Config (NCC) for Storage
# =====================================================================

module "ncc_storage" {
  count  = var.enable_ncc ? 1 : 0
  source = "./modules/ncc-storage"

  prefix   = var.prefix
  suffix   = random_string.global_suffix.result
  location = module.databricks_workspace.location
  workspace_id = module.databricks_workspace.workspace_resource_id

  storage_accounts = {
    metastore = {
      resource_id = module.unity_catalog.metastore_storage_account_id
      name        = module.unity_catalog.metastore_storage_account_name
    }
  }

  storage_group_id = var.storage_group_id

  depends_on = [module.unity_catalog]

  providers = {
    databricks.account = databricks.account
  }
}

# =====================================================================
# Auto-Approve Private Endpoint Connections
# =====================================================================

resource "time_sleep" "wait_for_pe_connections" {
  count           = var.enable_ncc ? 1 : 0
  create_duration = "30s"

  depends_on = [module.ncc_storage]
}

resource "null_resource" "approve_pe_metastore" {
  count = var.enable_ncc ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      sleep 10
      PE_IDS=$(az network private-endpoint-connection list \
        --id ${module.unity_catalog.metastore_storage_account_id} \
        --query "[?properties.privateLinkServiceConnectionState.status=='Pending'].id" \
        -o tsv)

      if [ ! -z "$PE_IDS" ]; then
        echo "$PE_IDS" | while IFS= read -r PE_ID; do
          if [ ! -z "$PE_ID" ]; then
            echo "Approving private endpoint: $PE_ID"
            az network private-endpoint-connection approve \
              --id "$PE_ID" \
              --description "Auto-approved by Terraform for NCC" || true
          fi
        done
      fi
    EOT
  }

  depends_on = [time_sleep.wait_for_pe_connections]
}
