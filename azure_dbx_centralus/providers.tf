terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.66.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "random" {
}

provider "azurerm" {
  features {}
  subscription_id = "72d2cdcb-dd88-4ef9-a253-fd33245017d5"
}
