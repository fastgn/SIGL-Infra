# subnet pour le stockage des données

# creation du groupe de ressources pour le backend
resource "azurerm_resource_group" "storage_rg" {
  name     = var.storage_rg_name
  location = var.location
}

# creer le vnet backend
resource "azurerm_virtual_network" "backend_vnet" {
  name                = var.backend_vnet_name
  location            = var.location
  resource_group_name = var.network_rg_name
  address_space       = ["10.2.0.0/16"]

}

# creation du sous-reseau pour le stockage
resource "azurerm_subnet" "storage_subnet" {
  name                 = "storage-subnet"
  resource_group_name  = var.network_rg_name
  virtual_network_name = var.backend_vnet_name
  address_prefixes     = ["10.2.3.0/24"]
  depends_on = [ azurerm_virtual_network.backend_vnet ]
}

# creation du compte de stockage
resource "azurerm_storage_account" "storage_account" {
  name                     = "siglstorageaccount"
  resource_group_name      = azurerm_resource_group.storage_rg.name
  location                 = azurerm_resource_group.storage_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# creation du disque managé pour le stockage
resource "azurerm_managed_disk" "storage_disk" {
  name                 = "sigl-storage-disk"
  location             = azurerm_resource_group.storage_rg.location
  resource_group_name  = azurerm_resource_group.storage_rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 64
  
}


