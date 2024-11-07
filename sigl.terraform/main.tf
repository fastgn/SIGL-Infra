# Fournisseur Azure pour le Frontend 
provider "azurerm" {
  alias           = "FrontendAccount"
  subscription_id = var.frontend_subscription_id
  features {
    
  }
}

# Fournisseur Azure pour le Backend 
provider "azurerm" {
  alias           = "BackendAccount"
  subscription_id = var.backend_subscription_id
    features {
        
    }
}

# Fournisseur Azure pour le Bastion
provider "azurerm" {
  alias           = "BastionAccount"
  subscription_id = var.bastion_subscription_id
    features {
        
    }
}

### Appel des modules 

# Module frontend et loadbalancer
module "frontend" {
  source               = "./modules/frontend"
  providers            = { azurerm = azurerm.FrontendAccount }
  location             = var.location
  frontend_rg_name     = var.frontend_rg_name
  network_rg_name      = var.network_rg_name
  loadbalancer_rg_name = var.loadbalancer_rg_name
}

# Module backend
module "backend" {
  source            = "./modules/backend"
  providers         = { azurerm = azurerm.BackendAccount }
  location          = var.location
  backend_rg_name   = var.backend_rg_name
  backend_vnet_name = var.backend_vnet_name
  network_rg_name   = var.network_rg_name
}

# Module bastion
module "bastion" {
  source            = "./modules/bastion"
  providers         = { azurerm = azurerm.BastionAccount }
  location          = var.location
  bastion_rg_name   = var.bastion_rg_name
  network_rg_name   = var.network_rg_name
  bastion_vnet_name = var.bastion_vnet_name
}

# Module database
module "database" {
  source                  = "./modules/database"
  providers               = { azurerm = azurerm.BackendAccount }
  location                = var.location
  database_rg_name        = var.database_rg_name
  backend_vnet_name       = var.backend_vnet_name
  network_rg_name         = var.network_rg_name
  database_admin_login    = var.database_admin_login
  database_admin_password = var.database_admin_password
  depends_on = [ module.backend ]
}

# Module storage
module "storage" {
  source            = "./modules/storage"
  providers         = { azurerm = azurerm.BackendAccount }
  location          = var.location
  storage_rg_name   = var.storage_rg_name
  backend_vnet_name = var.backend_vnet_name
  network_rg_name   = var.network_rg_name
}

# Module peering
module "peering" {
  source                   = "./modules/peering"
  location                 = var.location
  resource_group_name      = var.network_rg_name
  frontend_vnet_name       = var.frontend_vnet_name
  backend_vnet_name        = var.backend_vnet_name
  bastion_vnet_name        = var.bastion_vnet_name
  frontend_subscription_id = var.frontend_subscription_id
  backend_subscription_id  = var.backend_subscription_id
  bastion_subscription_id  = var.bastion_subscription_id
  network_rg_name          = var.network_rg_name
}
