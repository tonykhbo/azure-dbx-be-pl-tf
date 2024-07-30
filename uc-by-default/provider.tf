terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    databricks = {
      source = "databricks/databricks"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "random" {
}

provider "azurerm" {
  subscription_id = local.subscription_id
  features {}
}

provider "databricks" {
  alias = "workspace"
  host  = local.databricks_workspace_host
}

provider "databricks" {
  alias      = "accounts"
  account_id = var.account_console_id
  auth_type  = "azure-cli"
  host       = "https://accounts.azuredatabricks.net"
}