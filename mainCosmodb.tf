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

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "Taskify"
  location = "France Central"
}

# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "my-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Create Subnet within the Virtual Network
resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Cosmos DB Account
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "cosmodb-taskdb-taskify"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB" # NoSQL API (SQL)
  consistency_policy {
    consistency_level = "Eventual"
  }

  capabilities {
    name = "EnableServerless" # Enables Serverless mode
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }

  # IP range filter to allow access from specific IP
  ip_range_filter = "213.22.159.152/32" # Allow access from your IP
}

# Create Private Endpoint for Cosmos DB
resource "azurerm_private_endpoint" "cosmosdb_private_endpoint" {
  name                = "cosmodb-endpoint-taskify"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "cosmosdb-connection"
    private_connection_resource_id = azurerm_cosmosdb_account.cosmosdb.id
    is_manual_connection           = false
    subresource_names              = ["Sql"] # Correct subresource for Cosmos DB SQL API
  }
}

# Create Private DNS Zone
resource "azurerm_private_dns_zone" "cosmosdb_dns" {
  name                = "cosmosdb.zone"
  resource_group_name = azurerm_resource_group.rg.name
}

# Link Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdb_vnet_link" {
  name                  = "cosmosdb-vnet-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.cosmosdb_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = true
}
