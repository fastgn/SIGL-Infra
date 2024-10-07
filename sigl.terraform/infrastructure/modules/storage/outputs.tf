output "blob_storage_connection_string" {
  value = azurerm_storage_account.storage.primary_connection_string
}
output "storage_rg_id" {
  description = "ID of the storage resource group"
  value       = azurerm_resource_group.storage_rg.id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.storage_account.name
}

output "file_share_name" {
  description = "Name of the Azure File share"
  value       = azurerm_storage_share.azure_file_share.name
}

output "blob_container_name" {
  description = "Name of the Blob storage container"
  value       = azurerm_storage_container.blob_container.name
}

output "blob_name" {
  description = "Name of the Blob"
  value       = azurerm_storage_blob.blob.name
}

output "managed_disk_name" {
  description = "Name of the managed disk"
  value       = azurerm_managed_disk.managed_disk.name
}
