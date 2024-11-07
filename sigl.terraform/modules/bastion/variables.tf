# variables du module bastion

variable "bastion_rg_name" {
  description = "Nom du groupe de ressources pour le bastion"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "bastion_vnet_name" {
  description = "Nom du réseau virtuel pour le bastion"
  type        = string
  
}
variable "network_rg_name" {
  description = "Nom du groupe de ressources pour le réseau"
  type        = string
}
