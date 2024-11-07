variable "location" {
  type        = string
  description = "Location for the resources"
}

# Subscription IDs pour chaque fournisseur
variable "frontend_subscription_id" {
  type        = string
  description = "Subscription ID for the Frontend account"
}

variable "backend_subscription_id" {
  type        = string
  description = "Subscription ID for the Backend account"
}

variable "bastion_subscription_id" {
  type        = string
  description = "Subscription ID for the Bastion account"
}

# Resource Group names
variable "frontend_rg_name" {
  type        = string
  description = "Resource group name for Frontend"
}

variable "backend_rg_name" {
  type        = string
  description = "Resource group name for Backend"
}

variable "bastion_rg_name" {
  type        = string
  description = "Resource group name for Bastion"
}

variable "database_rg_name" {
  type        = string
  description = "Resource group name for Database"
}

variable "storage_rg_name" {
  type        = string
  description = "Resource group name for Storage"
}

variable "loadbalancer_rg_name" {
  type        = string
  description = "Resource group name for Loadbalancer"
}

# Virtual Network names
variable "frontend_vnet_name" {
  type        = string
  description = "Virtual network name for Frontend"
}

variable "backend_vnet_name" {
  type        = string
  description = "Virtual network name for Backend"
}

variable "bastion_vnet_name" {
  type        = string
  description = "Virtual network name for Bastion"
}

# Network Resource Group name
variable "network_rg_name" {
  type        = string
  description = "Resource group name for the network resources"
}

# Database credentials
variable "database_admin_login" {
  type        = string
  description = "Admin login for the database"
}

variable "database_admin_password" {
  type        = string
  description = "Admin password for the database"
  sensitive   = true
}
