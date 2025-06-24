variable "cosmos_db_account_name" {
  default = "cosmodb-taskify-v1"
}

locals {
  filtered_allowed_ips = [
    for ip in var.allowed_ips : trim(ip)
    if can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]+$", trim(ip)))
  ]
}

# Create Cosmos DB Account
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = var.cosmos_db_account_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB" # NoSQL API (SQL)
  # public_network_access_enabled = true


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

  ip_range_filter = join(",", local.filtered_allowed_ips)

  tags = azurerm_resource_group.rg.tags
}



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


# output the private DNS zone ID and name

output "dns_zone_id" {
  value = azurerm_private_dns_zone.cosmosdb_dns.id
}

output "dns_zone_name" {
  value = azurerm_private_dns_zone.cosmosdb_dns.name
}

output "dns_zone_link_id" {
  value = azurerm_private_dns_zone_virtual_network_link.cosmosdb_vnet_link.id
}
output "dns_zone_link_name" {
  value = azurerm_private_dns_zone_virtual_network_link.cosmosdb_vnet_link.name
}


# output the private endpoint ID and name

output "private_endpoint_id" {
  value = azurerm_private_endpoint.cosmosdb_private_endpoint.id
}

output "private_endpoint_name" {
  value = azurerm_private_endpoint.cosmosdb_private_endpoint.name
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
