# --- Resource Group ---
resource "azurerm_resource_group" "rg" {
  name     = "sigl-network-rg"
  location = var.location
}

# --- VNet pour le Frontend (Site A) ---
resource "azurerm_virtual_network" "frontend_vnet" {
  name                = "frontend-vnet"
  address_space       = ["10.0.1.0/24"]
  location            = azurerm_resource_group.frontend_rg.location
  resource_group_name = azurerm_resource_group.frontend_rg.name
}

# Subnet pour la vm frontend
resource "azurerm_subnet" "frontend_subnet" {
  name                 = "frontend-subnet"
  resource_group_name  = azurerm_resource_group.frontend_rg.name
  virtual_network_name = azurerm_virtual_network.frontend_vnet.name
  address_prefixes     = ["10.0.1.0/25"]
}

# --- VNet pour le Backend (Site B) ---
resource "azurerm_virtual_network" "vnet_backend" {
  name                = "vnet-backend"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet pour PostgreSQL
resource "azurerm_subnet" "subnet_postgresql" {
  name                 = "postgresql-database-subnet"
  resource_group_name  = azurerm_virtual_network.vnet_backend.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_backend.name
  address_prefixes     = ["10.1.2.0/24"]
}

# Subnet pour le Storage
resource "azurerm_subnet" "subnet_storage" {
  name                 = "storage-subnet"
  resource_group_name  = azurerm_virtual_network.vnet_backend.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_backend.name
  address_prefixes     = ["10.1.3.0/24"]
}

# --- VNet Peering ---
resource "azurerm_virtual_network_peering" "peer_frontend_to_backend" {
  name                      = "peering-frontend-to-backend"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet_frontend.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_backend.id
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "peer_backend_to_frontend" {
  name                      = "peering-backend-to-frontend"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet_backend.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_frontend.id
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true
}

# --- Public IP pour le Load Balancer ---
resource "azurerm_public_ip" "public_ip_lb" {
  name                = "public-ip-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


