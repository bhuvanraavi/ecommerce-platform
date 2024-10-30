
output "azurerm_resource_group_name" {
  description = "Resource Group Name"
  value       = azurerm_resource_group.example.name
}
output "azurerm_storage_account_name" {
  description = "Storage Account Name"
  value       = azurerm_storage_account.example.name
}

output "azurerm_storage_container_name" {
  description = "Storage Account Container Name"
  value       = azurerm_storage_container.example.name
}