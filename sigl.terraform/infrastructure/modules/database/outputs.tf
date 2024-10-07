output "connection_string" {
  value = "Server=${azurerm_postgresql_server.postgresql.fqdn};Database=${azurerm_postgresql_database.database.name};User Id=${azurerm_postgresql_server.postgresql.administrator_login};Password=${azurerm_postgresql_server.postgresql.administrator_login_password};"
}