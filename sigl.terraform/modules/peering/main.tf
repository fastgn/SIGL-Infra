# Fournisseur Azure pour le frontend 
provider "azurerm" {
  alias           = "FrontendAccount"
  features        {}
  subscription_id = var.frontend_subscription_id 
}

# Fournisseur Azure pour le Backend 
provider "azurerm" {
  alias           = "BackendAccount"
  features        {}
  subscription_id = var.backend_subscription_id  
}

# Fournisseur Azure pour le Bastion 
provider "azurerm" {
  alias           = "BastionAccount"
  features        {}
  subscription_id = var.bastion_subscription_id
}

# Récupérer le VNet sur le frontend
data "azurerm_virtual_network" "frontend_vnet" {
  provider            = azurerm.FrontendAccount
  name                = var.frontend_vnet_name
  resource_group_name = var.network_rg_name
}

# Récupérer le VNet sur le Backend
data "azurerm_virtual_network" "backend_vnet" {
  provider            = azurerm.BackendAccount
  name                = var.backend_vnet_name
  resource_group_name = var.network_rg_name
}

# Récupérer le VNet sur le Bastion
data "azurerm_virtual_network" "bastion_vnet" {
  provider            = azurerm.BastionAccount
  name                = var.bastion_vnet_name
  resource_group_name = var.network_rg_name
}

# Peering du VNet Frontend vers Backend 
resource "azurerm_virtual_network_peering" "frontend_to_backend" {
  provider                  = azurerm.FrontendAccount
  name                      = "frontend-to-backend"
  resource_group_name       = var.network_rg_name
  virtual_network_name      = data.azurerm_virtual_network.frontend_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.backend_vnet.id
  allow_forwarded_traffic       = true
  allow_virtual_network_access  = true
  allow_gateway_transit = false
  
}

# Peering du VNet Backend vers Frontend 
resource "azurerm_virtual_network_peering" "backend_to_frontend" {
  provider                  = azurerm.BackendAccount
  name                      = "backend-to-frontend"
  resource_group_name       = var.network_rg_name
  virtual_network_name      = data.azurerm_virtual_network.backend_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.frontend_vnet.id

  allow_forwarded_traffic       = true
  allow_virtual_network_access  = true
  allow_gateway_transit = false

  depends_on = [azurerm_virtual_network_peering.frontend_to_backend]
}

# Peering du VNet Bastion vers Frontend
resource "azurerm_virtual_network_peering" "bastion_to_frontend" {
  provider                  = azurerm.BastionAccount
  name                      = "bastion-to-frontend"
  resource_group_name       = var.network_rg_name
  virtual_network_name      = data.azurerm_virtual_network.bastion_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.frontend_vnet.id

  allow_forwarded_traffic       = true
  allow_virtual_network_access  = true
  allow_gateway_transit = false
}

# Peering du VNet Bastion vers Backend
resource "azurerm_virtual_network_peering" "bastion_to_backend" {
  provider                  = azurerm.BastionAccount
  name                      = "bastion-to-backend"
  resource_group_name       = var.network_rg_name
  virtual_network_name      = data.azurerm_virtual_network.bastion_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.backend_vnet.id

  allow_forwarded_traffic       = true
  allow_virtual_network_access  = true
  allow_gateway_transit = false

  depends_on = [
    azurerm_virtual_network_peering.bastion_to_frontend,
    azurerm_virtual_network_peering.frontend_to_backend,
    azurerm_virtual_network_peering.backend_to_frontend
  ]
}

# Peering du VNet Frontend vers Bastion
resource "azurerm_virtual_network_peering" "frontend_to_bastion" {
  provider                  = azurerm.FrontendAccount
  name                      = "frontend-to-bastion"
  resource_group_name       = var.network_rg_name
  virtual_network_name      = data.azurerm_virtual_network.frontend_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.bastion_vnet.id

  allow_forwarded_traffic       = true
  allow_virtual_network_access  = true
  allow_gateway_transit = false
}

# Peering du VNet Backend vers Bastion

resource "azurerm_virtual_network_peering" "backend_to_bastion" {
  provider                  = azurerm.BackendAccount
  name                      = "backend-to-bastion"
  resource_group_name       = var.network_rg_name
  virtual_network_name      = data.azurerm_virtual_network.backend_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.bastion_vnet.id

  allow_forwarded_traffic       = true
  allow_virtual_network_access  = true
  allow_gateway_transit = false

  depends_on = [
    azurerm_virtual_network_peering.frontend_to_backend,
    azurerm_virtual_network_peering.backend_to_frontend,
    azurerm_virtual_network_peering.bastion_to_frontend
  ]
}