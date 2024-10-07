# # --- Resource Group (utilisé pour la sécurité réseau) ---

# # teste si je peux acerder à des ressources dans un autre groupe de ressources
# resource "azurerm_resource_group" "rg_security" {
#   name     = azurerm_resource_group.rg.name  
#   location = azurerm_resource_group.rg.location
# }

# # --- NSG pour le Frontend (Site A) ---
# resource "azurerm_network_security_group" "nsg_frontend" {
#   name                = "frontend-secure-network"
#   location            = azurerm_resource_group.rg_security.location
#   resource_group_name = azurerm_resource_group.rg_security.name

#   security_rule {
#     name                       = "Allow_HTTP_Inbound"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "VirtualNetwork"
#   }

#   security_rule {
#     name                       = "Allow_HTTPS_Inbound"
#     priority                   = 110
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "*"
#     destination_address_prefix = "VirtualNetwork"
#   }

#   security_rule {
#     name                       = "Allow_Backend_To_Frontend"
#     priority                   = 200
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = azurerm_virtual_network.vnet_backend.address_space[0]
#     destination_address_prefix = "VirtualNetwork"
#   }

#   security_rule {
#     name                       = "Deny_All_Inbound"
#     priority                   = 300
#     direction                  = "Inbound"
#     access                     = "Deny"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "VirtualNetwork"
#   }
# }

# # --- NSG pour le Backend (Site B) ---
# resource "azurerm_network_security_group" "nsg_backend" {
#   name                = "backend-secure-network"
#   location            = azurerm_resource_group.rg_security.location
#   resource_group_name = azurerm_resource_group.rg_security.name

#   security_rule {
#     name                       = "Allow_Frontend_To_Backend"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = azurerm_virtual_network.vnet_frontend.address_space[0]
#     destination_address_prefix = "VirtualNetwork"
#   }

#   security_rule {
#     name                       = "Allow_PostgreSQL_Inbound"
#     priority                   = 110
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "5432"
#     source_address_prefix      = azurerm_virtual_network.vnet_frontend.address_space[0]
#     destination_address_prefix = "VirtualNetwork"
#   }

#   security_rule {
#     name                       = "Deny_All_Inbound"
#     priority                   = 200
#     direction                  = "Inbound"
#     access                     = "Deny"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "VirtualNetwork"
#   }
# }

# # --- Associer les NSGs aux Subnets ---
# # Associer NSG du Frontend aux subnets du Frontend (Proxy et Frontend VMs)
# resource "azurerm_subnet_network_security_group_association" "frontend_proxy_nsg_assoc" {
#   subnet_id                 = azurerm_subnet.subnet_proxy.id
#   network_security_group_id = azurerm_network_security_group.nsg_frontend.id
# }

# resource "azurerm_subnet_network_security_group_association" "frontend_vms_nsg_assoc" {
#   subnet_id                 = azurerm_subnet.subnet_frontend_vms.id
#   network_security_group_id = azurerm_network_security_group.nsg_frontend.id
# }

# # Associer NSG du Backend aux subnets du Backend (API, PostgreSQL, Storage)
# resource "azurerm_subnet_network_security_group_association" "backend_api_nsg_assoc" {
#   subnet_id                 = azurerm_subnet.subnet_backend_api.id
#   network_security_group_id = azurerm_network_security_group.nsg_backend.id
# }

# resource "azurerm_subnet_network_security_group_association" "backend_postgresql_nsg_assoc" {
#   subnet_id                 = azurerm_subnet.subnet_postgresql.id
#   network_security_group_id = azurerm_network_security_group.nsg_backend.id
# }

# resource "azurerm_subnet_network_security_group_association" "backend_storage_nsg_assoc" {
#   subnet_id                 = azurerm_subnet.subnet_storage.id
#   network_security_group_id = azurerm_network_security_group.nsg_backend.id
# }
