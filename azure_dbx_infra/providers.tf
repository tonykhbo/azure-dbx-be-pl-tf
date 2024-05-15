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
}
