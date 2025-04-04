variable "resource_group_name" {
  default = "Taskify"
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Team        = var.team
  }
}
