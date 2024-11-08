# definition des variables pour le module peering

variable "frontend_subscription_id" {
  description = "ID du compte azure pour le frontend"
  type        = string  
}

variable "backend_subscription_id" {
  description = "ID du compte Azure pour le backend"
  type        = string  
}

variable "bastion_subscription_id" {
  description = "ID du compte Azure pour le bastion"
  type        = string  
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du groupe de ressources pour l'infrastructure"
  type        = string
}

variable "frontend_vnet_name" {
  description = "Nom du VNet du frontend"
  type        = string
  
}

variable "backend_vnet_name" {
  description = "Nom du VNet du backend"
  type        = string  
}

variable "bastion_vnet_name" {
  description = "Nom du VNet du bastion"
  type        = string  
  
}

variable "network_rg_name" {
  description = "Nom du groupe de ressources pour le réseau"
  type        = string  
}