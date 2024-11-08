# module de definition des vms de l'infrastucture sigl

# groupe de ressources pour le frontend
variable "frontend_rg_name" {
  description = "Nom du groupe de ressources pour le frontend"
  type        = string  
}

# Localisation
variable "location" {
  description = "Azure Region"
  type        = string
}

# groupe de ressources pour le réseau
variable "network_rg_name" {
  description = "Nom du groupe de ressources pour le réseau"
  type        = string
}

# groupe de ressources pour le loadbalancer
variable "loadbalancer_rg_name" {
  description = "Nom du groupe de ressources pour le loadbalancer"
  type        = string
}


# Noms des groupes de ressources
variable "resource_group_name" {
  description = "Nom du groupe de ressources pour l'infrastructure"
  type        = string
  default     = "sigl_infra_rg"
}

