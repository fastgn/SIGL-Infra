# variables de configurations de deploiement
# Variables pour Site A
variable "subscription_id_frontend" {
  type = string
}

variable "client_id_frontend" {
  type = string
}

variable "client_secret_frontend" {
  type = string
}

variable "tenant_id_frontend" {
  type = string
}

# Variables pour Site B
variable "subscription_id_backend" {
  type = string
}

variable "client_id_backend" {
  type = string
}

variable "client_secret_backend" {
  type = string
}

variable "tenant_id_backend" {
  type = string
}


# Localisation
variable "location" {
  description = "Azure Region"
  type        = string
  default     = "francecentral"
}

# Noms des groupes de ressources
variable "resource_group_name" {
  description = "Nom du groupe de ressources pour l'infrastructure"
  type        = string
}

# Variables pour le réseau
variable "vnet_frontend_cidr" {
  description = "CIDR pour le réseau VNet du frontend"
  type        = string
  default     = "10.0.1.0/24"
}

variable "vnet_backend_cidr" {
  description = "CIDR pour le réseau VNet du backend"
  type        = string
  default     = "10.1.0.0/16"
}

variable "subnet_cidrs" {
  description = "Liste des CIDRs pour les subnets"
  type        = map(string)
  default = {
    frontend  = "10.0.1.0/25"
    backend   = "10.1.1.0/24"
    database  = "10.1.2.0/24"
    storage   = "10.1.3.0/24"
  }
}

variable "database_admin_name" {
  description = "Le nom d'utilisateur admin pour PostgreSQL"
  type        = string
}

variable "database_admin_password" {
  description = "Le mot de passe pour l'administrateur PostgreSQL"
  type        = string
  sensitive   = true
}

variable "storage_account_name" {
  description = "Le nom du compte de stockage Azure"
  type        = string
}
