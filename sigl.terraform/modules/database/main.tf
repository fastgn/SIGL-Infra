# Création d'une base de données PostgreSQL

# Création d'un groupe de ressources pour la base de données
resource "azurerm_resource_group" "database_rg" {
  name     = var.database_rg_name
  location = var.location
}

# Recherche du groupe de ressources pour le réseau
data "azurerm_resource_group" "network_rg" {
  name = var.network_rg_name
}

# Création du VNet backend
resource "azurerm_virtual_network" "backend_vnet" {
  name                = var.backend_vnet_name
  location            = var.location
  resource_group_name = var.network_rg_name
  address_space       = ["10.2.0.0/16"]
}

# Création du sous-réseau pour la base de données
resource "azurerm_subnet" "database_subnet" {
  name                 = "database-subnet"
  resource_group_name  = var.network_rg_name
  virtual_network_name = azurerm_virtual_network.backend_vnet.name
  address_prefixes     = ["10.2.2.0/24"]
  
  delegation {
    name = "postgresql_delegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# Définition de la zone DNS privée
resource "azurerm_private_dns_zone" "database_dns_zone" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.database_rg.name
}

# Lien de la zone DNS privée avec le VNet
resource "azurerm_private_dns_zone_virtual_network_link" "pgsql_dns_link" {
  name                  = "pgsql-dns-link"
  private_dns_zone_name = azurerm_private_dns_zone.database_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.backend_vnet.id
  resource_group_name   = azurerm_resource_group.database_rg.name
}

# Création du serveur flexible de base de données
resource "azurerm_postgresql_flexible_server" "postgresql_server" {
  name                   = "sigl-postgresql-server"
  resource_group_name    = azurerm_resource_group.database_rg.name
  location               = azurerm_resource_group.database_rg.location
  version                = "14"
  delegated_subnet_id    = azurerm_subnet.database_subnet.id
  administrator_login    = var.database_admin_login
  administrator_password = var.database_admin_password
  storage_tier           = "P6"
  storage_mb             = 32768
  zone                   = "1"
  backup_retention_days  = 7
  private_dns_zone_id    = azurerm_private_dns_zone.database_dns_zone.id
  sku_name               = "B_Standard_B1ms"  # SKU n'exige pas de haute disponibilité
  tags = {
    environment = "development"
  }

  auto_grow_enabled              = false
  geo_redundant_backup_enabled   = false
  public_network_access_enabled   = false
}

# Création de la base de données PostgreSQL
resource "azurerm_postgresql_flexible_server_database" "postgresql_database" {
  name       = "sigl-database"
  server_id  = azurerm_postgresql_flexible_server.postgresql_server.id
  charset    = "UTF8"
  collation  = "en_US.utf8"
  depends_on = [azurerm_postgresql_flexible_server.postgresql_server]
}

# Règle de pare-feu pour autoriser le backend
resource "azurerm_postgresql_flexible_server_firewall_rule" "database_fw_backend" {
  name             = "database-fw-rule"
  server_id        = azurerm_postgresql_flexible_server.postgresql_server.id
  start_ip_address = "10.2.1.0"
  end_ip_address   = "10.2.1.255"

  depends_on = [azurerm_postgresql_flexible_server.postgresql_server]
}

# Règle de pare-feu pour autoriser le bastion SSH
resource "azurerm_postgresql_flexible_server_firewall_rule" "database_fw_bastion" {
  name             = "database-fw-bastion-rule"
  server_id        = azurerm_postgresql_flexible_server.postgresql_server.id
  start_ip_address = "10.3.1.0"
  end_ip_address   = "10.3.1.255"

  depends_on = [azurerm_postgresql_flexible_server.postgresql_server]
}

# Création du NSG pour la base de données
resource "azurerm_network_security_group" "database_nsg" {
  name                = "database-nsg"
  location            = azurerm_resource_group.database_rg.location
  resource_group_name = azurerm_resource_group.database_rg.name
}

# Création de la règle de sécurité pour la base de données
resource "azurerm_network_security_rule" "database_nsg_rule" {
  name                        = "database-nsg-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"
  source_address_prefix       = "10.2.1.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.database_rg.name
  network_security_group_name = azurerm_network_security_group.database_nsg.name
}

# Règle NSG additionnelle pour le bastion SSH
resource "azurerm_network_security_rule" "bastion_nsg_rule" {
  name                        = "bastion-nsg-rule"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"
  source_address_prefix       = "10.3.1.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.database_rg.name
  network_security_group_name = azurerm_network_security_group.database_nsg.name
}



# Association du NSG à la sous-reseau de la base de données
resource "azurerm_subnet_network_security_group_association" "database_nsg_association" {
  subnet_id                 = azurerm_subnet.database_subnet.id
  network_security_group_id = azurerm_network_security_group.database_nsg.id
}
