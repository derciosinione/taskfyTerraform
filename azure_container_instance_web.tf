
# variable "container_name" {
#   type        = string
#   description = "Nome do Azure Container Instance"
#   default     = "taskfy-web-container-instance"
# }

# variable "web_container_image" {
#   type        = string
#   description = "Imagem do container para o Azure Container Instance"
#   default     = "taskfy-web:latest"
# }

# variable "dns_label" {
#   type    = string
#   default = "taskfy-web"
# }


# # Azure Container Instance
# resource "azurerm_container_group" "taskfy" {
#   name                = "taskfy-container"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   os_type             = "Linux"

#   container {
#     name   = var.container_name
#     image  = "${azurerm_container_registry.acr.login_server}/${var.web_container_image}"
#     cpu    = 1
#     memory = 1.5

#     ports {
#       port     = 8080
#       protocol = "TCP"
#     }

#     # ports {
#     #   port     = 80
#     #   protocol = "TCP"
#     # }

#     environment_variables = {
#       PORT = "8080"
#     }

#   }

#   image_registry_credential {
#     server   = azurerm_container_registry.acr.login_server
#     username = azurerm_container_registry.acr.admin_username
#     password = azurerm_container_registry.acr.admin_password
#   }

#   ip_address_type = "Public"
#   dns_name_label  = var.dns_label

#   tags = {
#     environment = "production"
#   }
# }
