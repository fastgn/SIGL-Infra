# variable de stockage

variable "storage_rg_name" {
  description = "Nom du groupe de ressources pour le stockage"
  type        = string
  
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "network_rg_name" {
  description = "Nom du groupe de ressources pour le réseau"
  type        = string
  
}

variable "backend_vnet_name" {
  description = "Nom du groupe de ressources pour le backend"
  type        = string
}