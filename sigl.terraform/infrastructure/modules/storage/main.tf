resource "azurerm_resource_group" "storage_rg" {
  name     = "storage-rg"
  location = var.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.storage_rg.name
  location                 = azurerm_resource_group.storage_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "azure_file_share" {
  name                = "AzureFileShare"
  storage_account_name = azurerm_storage_account.storage_account.name
  quota               = 100
}

resource "azurerm_managed_disk" "managed_disk" {
  name                 = "managed-disk"
  location             = azurerm_resource_group.storage_rg.location
  resource_group_name  = azurerm_resource_group.storage_rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         =  64
}

# resource "azurerm_storage_blob" "blob" {
#   name                   = "sigl_blob"
#   storage_account_name   = azurerm_storage_account.storage_account.name
#   storage_container_name = azurerm_storage_container.blob_container.name
#   type                   = "page"
# }

# resource "azurerm_storage_container" "blob_container" {
#   name                  = "blob-container"
#   storage_account_name  = azurerm_storage_account.storage_account.name
#   container_access_type = "private"
# }

