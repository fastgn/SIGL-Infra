variable "database_url" {
  description = "The URL for the PostgreSQL database."
  type        = string
}

variable "vnet_id" {
  description = "The ID of the VNet where the backend will be deployed."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources."
  type        = string
  default     = "francecentral"
}

variable "prefix" {
  description = "Prefix for resource names."
  type        = string
  default     = "myapp"
}