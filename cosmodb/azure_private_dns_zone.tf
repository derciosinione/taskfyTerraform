# Create Private DNS Zone
resource "azurerm_private_dns_zone" "cosmosdb_dns" {
  name                = "cosmosdb.zone"
  resource_group_name = azurerm_resource_group.rg.name

  tags = azurerm_resource_group.rg.tags
}

# Link Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdb_vnet_link" {
  name                  = "cosmosdb-vnet-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.cosmosdb_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = true

  tags = azurerm_resource_group.rg.tags
}
