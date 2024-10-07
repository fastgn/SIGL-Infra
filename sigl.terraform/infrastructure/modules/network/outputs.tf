output "rg_name" {
  description = "Nom du groupe de ressources réseau"
  value       = azurerm_resource_group.rg.name
}

output "vnet_frontend_id" {
  description = "ID du VNet pour le frontend"
  value       = azurerm_virtual_network.frontend_vnet.id
}

output "vnet_backend_id" {
  description = "ID du VNet pour le backend"
  value       = azurerm_virtual_network.backend_vnet.id
}

output "database_rg_name" {
  description = "Nom du groupe de ressources pour la base de données"
  value       = azurerm_resource_group.database_rg.name
}
