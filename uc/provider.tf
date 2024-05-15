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
  account_id = "827e3e09-89ba-4dd2-9161-a3301d0f21c0"
  auth_type  = "azure-cli"
  host       = "https://accounts.azuredatabricks.net"
}