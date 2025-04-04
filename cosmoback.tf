terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  #   cloud {
  #     organization = "KiariCode"
  #     workspaces {
  #       name = "learn-terraform-azure"
  #     }
  #   }
  #   required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

variable "resource_group_name" {
  default = "Taskify"
}

# variable "app_name" {
#   default = "taskify-app"
# }

variable "location" {
  default = "francecentral"
}

variable "environment" {
  default = "Taskify Demo"
}

variable "team" {
  default = "DevOps"
}

variable "cosmos_db_account_name" {
  default = "cosmosdb_taskify"
}

resource "azurerm_resource_group" "group" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Team        = var.team
  }
}

# Virtual Network Resource
resource "azurerm_virtual_network" "taskfy_subnet" {
  name                = "taskify-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.group.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet Resource (Default subnet)
resource "azurerm_subnet" "taskify_subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.group.name
  virtual_network_name = azurerm_virtual_network.name.name
  address_prefixes     = ["10.0.1.0/24"]
}


# Azure Cosmos DB Account Resource
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = var.cosmos_db_account_name
  location            = var.location
  resource_group_name = azurerm_resource_group.group.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB" # For NoSQL API

  consistency_policy {
    consistency_level = "Eventual"
  }

  # Capacity mode set to serverless
  capabilities {
    name = "EnableServerless"
  }

  # Geo Location block (needed for Cosmos DB creation)
  geo_location {
    location          = var.location
    failover_priority = 0
  }

  # Enable public network access for the Cosmos DB account
  public_network_access_enabled = true

  tags = {
    Environment = var.environment
    Team        = var.team
  }
}

# Private Endpoint Resource to connect to Cosmos DB
resource "azurerm_private_endpoint" "cosmos_endpoint" {
  name                = "cosmos-endpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.group.name
  subnet_id           = azurerm_subnet.taskify_subnet.id

  private_service_connection {
    name                           = "cosmos-db-priv-link"
    private_connection_resource_id = azurerm_cosmosdb_account.cosmosdb.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }

  tags = {
    Environment = var.environment
    Team        = var.team
  }
}

# az cosmosdb update \
#   --name <cosmos-account-name> \
#   --resource-group <resource-group-name> \
#   --set workloadType=Learning
