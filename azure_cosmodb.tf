variable "cosmos_db_account_name" {
  default = "cosmodb-taskdb-taskify"
}


# Create Cosmos DB Account
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = var.cosmos_db_account_name
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
  ip_range_filter = var.ip_range_filter # Allow access from your IP

  tags = azurerm_resource_group.rg.tags
}


# output the Cosmos DB account ID, name, and endpoint

output "cosmosdb_account_id" {
  value = azurerm_cosmosdb_account.cosmosdb.id
}

output "cosmosdb_account_name" {
  value = azurerm_cosmosdb_account.cosmosdb.name
}

output "cosmosdb_account_endpoint" {
  value = azurerm_cosmosdb_account.cosmosdb.endpoint
}
