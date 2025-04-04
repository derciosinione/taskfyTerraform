
variable "storage_account_name" {
  default = "storagetaskfy"
}


# Create Storage Account with private endpoint
resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


# Create Network Security Group (NSG) for access control (allow your IP)
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
    source_address_prefix      = var.ip_range_filter
    destination_address_prefix = "*"
  }
}

# Associate NSG to subnet
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}

# Create Storage Account Access Policy for Portal Access
resource "azurerm_storage_account_network_rules" "storage_account_network_rules" {
  storage_account_id = azurerm_storage_account.storage_account.id

  default_action = "Deny"

  ip_rules = [
    var.ip_address
  ]

  virtual_network_subnet_ids = [
    azurerm_subnet.subnet.id # Subnet ID to restrict access to the private network
  ]
}

