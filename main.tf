terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  cloud {
    organization = "KiariCode"
    workspaces {
      name = "learn-terraform-azure"
    }
  }
  required_version = ">= 1.1.0"
}


provider "azurerm" {
  features {}
}


