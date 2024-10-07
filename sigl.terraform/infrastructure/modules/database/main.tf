resource "azurerm_resource_group" "database_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_postgresql_server" "postgresql" {
  name                = "sigl-postgresql-db"
  resource_group_name = azurerm_resource_group.database_rg.name
  location            = var.location
  administrator_login          = var.database_admin_name
  administrator_login_password = var.database_admin_password
  sku_name   = "GP_Gen5_4"
  version    = "16.0"
  storage_mb = 32000 # je dois verifier la taille pour etre dans les limites de l'offre Azure Student
  backup_retention_days        = 30
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true
  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_database" "database" {
  name                = "sigl-database"
  resource_group_name = azurerm_resource_group.database_rg.name
  server_name         = azurerm_postgresql_server.postgresql.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
    # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

