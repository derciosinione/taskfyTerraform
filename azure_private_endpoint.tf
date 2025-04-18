
# Create Private Endpoint for Cosmos DB
resource "azurerm_private_endpoint" "cosmosdb_private_endpoint" {
  name                = "cosmodb-private-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "cosmosdb-private-connection"
    private_connection_resource_id = azurerm_cosmosdb_account.cosmosdb.id
    is_manual_connection           = false
    subresource_names              = ["Sql"] # Correct subresource for Cosmos DB SQL API
  }

  tags = azurerm_resource_group.rg.tags
}


# output the private endpoint ID and name

output "private_endpoint_id" {
  value = azurerm_private_endpoint.cosmosdb_private_endpoint.id
}

output "private_endpoint_name" {
  value = azurerm_private_endpoint.cosmosdb_private_endpoint.name
}
