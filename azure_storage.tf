
variable "storage_account_name" {
  default = "storagetaskfy"
}


resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_private_endpoint" "storage_private_endpoint" {
  name                = "storage-private-endpoint"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "storage-private-connection"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = "taskify-network-security-group"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-MyIP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = ["89.155.125.86/32", "213.22.159.152/32", "193.137.66.216/32", "193.137.66.206/32"]
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}

resource "azurerm_storage_account_network_rules" "storage_account_network_rules" {
  storage_account_id = azurerm_storage_account.storage_account.id

  default_action = "Deny"
  bypass         = ["AzureServices"]

  ip_rules = [
    var.ip_address
  ]

  virtual_network_subnet_ids = [
    azurerm_subnet.subnet.id
  ]
}

resource "azurerm_storage_container" "blob_container" {
  name                  = "taskfy-blob-container"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}
