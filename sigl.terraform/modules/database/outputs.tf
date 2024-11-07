# sortie pour la base de données et le serveur

output "database_name" {
  value = azurerm_postgresql_flexible_server.postgresql_server.name
  
}

output "postgresql_server_id" {
  value = azurerm_postgresql_flexible_server.postgresql_server.id
  
}


