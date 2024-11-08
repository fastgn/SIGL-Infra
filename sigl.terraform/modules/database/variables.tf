# variable de base de données

variable "database_rg_name" {
  description = "Nom du groupe de ressources pour la base de données"
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
  description = "Nom du réseau virtuel pour le backend"
  type        = string
  
}

variable "database_admin_password" {
  description = "Nom de l'administrateur de la base de données"
  type        = string
  
}

variable "database_admin_login" {
  description = "Mot de passe de l'administrateur de la base de données"
  type        = string
  
}

variable "postgresql_server_name" {
  description = "ID du serveur PostgreSQL"
  type        = string
  default = "sigl-postgresql-server"
  
}