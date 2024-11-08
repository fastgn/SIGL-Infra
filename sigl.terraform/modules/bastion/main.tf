# Module de ressources pour le bastion

# Création du groupe de ressources pour le bastion
resource "azurerm_resource_group" "bastion_rg" {
  name     = var.bastion_rg_name
  location = var.location
}

# creation du groupe de ressources pour le reseau
resource "azurerm_resource_group" "network_rg" {
  name     = var.network_rg_name
  location = var.location
}

# Création du réseau virtuel pour le bastion
resource "azurerm_virtual_network" "bastion_vnet" {
  name                = var.bastion_vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.network_rg.name
  address_space       = ["10.3.0.0/16"]
  depends_on = [ azurerm_resource_group.network_rg ]
}

# Création du sous-réseau pour le serveur bastion
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "bastion-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.bastion_vnet.name
  address_prefixes     = ["10.3.1.0/24"]
  depends_on = [ azurerm_virtual_network.bastion_vnet ]
}

# Création de l'adresse IP publique pour le bastion
resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "bastion-public-ip"
  location            = azurerm_resource_group.bastion_rg.location
  resource_group_name = azurerm_resource_group.bastion_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label = "sigl-admin-bastion"
  depends_on = [ azurerm_resource_group.bastion_rg ]
}

# Création de la carte réseau pour le serveur bastion
resource "azurerm_network_interface" "bastion_nic" {
  name                = "bastion-nic"
  location            = azurerm_resource_group.bastion_rg.location
  resource_group_name = azurerm_resource_group.bastion_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.bastion_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion_public_ip.id  # Associe l'IP publique
  }

  depends_on = [ azurerm_subnet.bastion_subnet , azurerm_public_ip.bastion_public_ip , azurerm_resource_group.bastion_rg ]
}

# Création de la machine virtuelle pour le bastion
resource "azurerm_linux_virtual_machine" "bastion_vm" {
  name                  = "sigl-bastion-server"
  location              = azurerm_resource_group.bastion_rg.location
  resource_group_name   = azurerm_resource_group.bastion_rg.name
  network_interface_ids = [azurerm_network_interface.bastion_nic.id]
  size                  = "Standard_B2ats_v2"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  computer_name  = "sigl-bastion-server"
  admin_username = "sigladmin"

  admin_ssh_key {
    username   = "sigladmin"
    public_key = tls_private_key.bastion_ssh_key.public_key_openssh  # Gestion du fichier SSH
  }

  provision_vm_agent = true
  depends_on = [ azurerm_network_interface.bastion_nic ]
}

# Création du NSG pour le bastion
resource "azurerm_network_security_group" "bastion_nsg" {
  name                = "bastion-nsg"
  location            = azurerm_resource_group.bastion_rg.location
  resource_group_name = azurerm_resource_group.bastion_rg.name
}

# Ajout d'une règle NSG pour autoriser le trafic SSH
resource "azurerm_network_security_rule" "bastion_ssh_rule" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22" 
  source_address_prefix       = "*"   
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.bastion_rg.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}

# Ajout d'une règle NSG pour autoriser le trafic SSH
resource "azurerm_network_security_rule" "bastion_https_rule" {
  name                        = "allow-https"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"   
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.bastion_rg.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}



# Association du NSG avec le sous-réseau du bastion
resource "azurerm_subnet_network_security_group_association" "bastion_nsg_association" {
  subnet_id                 = azurerm_subnet.bastion_subnet.id
  network_security_group_id = azurerm_network_security_group.bastion_nsg.id
  depends_on = [ azurerm_subnet.bastion_subnet , azurerm_network_security_group.bastion_nsg ]
}
