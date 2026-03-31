terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.66.0"
    }
    databricks = {
      source = "databricks/databricks"
    }
    random = {
      source = "hashicorp/random"
    }
    time = {
      source = "hashicorp/time"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

data "azurerm_client_config" "current" {}

provider "random" {}
provider "time" {}
provider "null" {}

# Provider for account-level operations (Unity Catalog, NCC)
provider "databricks" {
  alias      = "account"
  account_id = var.databricks_account_id
  auth_type  = "azure-cli"
  host       = "https://accounts.azuredatabricks.net"
}

# Provider for workspace-level operations
provider "databricks" {
  alias = "workspace"
  host  = module.databricks_workspace.workspace_url
}
