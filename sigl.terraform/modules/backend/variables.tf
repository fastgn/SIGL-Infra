# variables du module backend

variable "backend_rg_name" {
  description = "Nom du groupe de ressources pour le backend"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "backend_vnet_name" {
  description = "Nom du réseau virtuel pour le backend"
  type        = string
  
}
variable "network_rg_name" {
  description = "Nom du groupe de ressources pour le réseau"
  type        = string
}
