variable "location" {
  description = "The Azure region to deploy resources."
  type        = string
  default     = "francecentral"
}

variable "storage_account_name" {
  description = "The name of the storage account."
  type        = string
  default     = "siglStorageAccount"
}