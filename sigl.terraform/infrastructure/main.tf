provider "azurerm" {
  features {}
}

# Appel du module Réseau (Network)
module "network" {
  source              = "./modules/network"
  location            = var.location
}

# Appel du module Load Balancer
module "load_balancer" {
  source              = "./modules/loadbalancer"
  providers = {
    azurerm = azurerm.frontend
  }
  lb_name             = "sigl-public-lb"
  location            = var.location
  resource_group_name = module.network.rg_name
  frontend_vm_ids     = module.frontend.vm_ids # Les IDs des VMs frontend
}

# Appel du module Frontend
module "frontend" {
  source                        = "./modules/frontend"
  providers = {
    azurerm = azurerm.frontend
  }
  location                      = var.location
  load_balancer_backend_pool_id = module.load_balancer.backend_pool_id
  vnet_id                       = module.network.vnet_frontend_id
  public_ip                     = module.load_balancer.public_ip
}

# Appel du module Backend
module "backend" {
  source   = "./modules/backend"
    providers = {
    azurerm = azurerm.backend
  }
  location = var.location
  vnet_id  = module.network.vnet_backend_id
  database_url = module.database.database_url
}

# Appel du module Base de Données PostgreSQL
module "database" {
  source                  = "./modules/database"
    providers = {
    azurerm = azurerm.backend
  }
  location                = var.location
  resource_group_name     = module.network.database_rg_name
  database_admin_name     = var.database_admin_name
  database_admin_password = var.database_admin_password
}

# Appel du module de Stockage
module "storage" {
  source              = "./modules/storage"
  providers = {
    azurerm = azurerm.backend
  }
  location            = var.location
  storage_account_name = var.storage_account_name
}
