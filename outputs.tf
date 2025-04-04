output "resource_group_id" {
  value = azurerm_resource_group.group.id
}


output "service_plan_id" {
  value = azurerm_service_plan.plan.id
}

output "app_service_url" {
  value       = "https://${azurerm_linux_web_app.app.default_hostname}"
  description = "The URL of the deployed App Service"
}
