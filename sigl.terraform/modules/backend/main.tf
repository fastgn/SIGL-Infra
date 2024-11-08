# module de resources pour le backend

# creation du groupe de ressources pour le backend
resource "azurerm_resource_group" "backend_rg" {
  name     = var.backend_rg_name
  location = var.location
}

# creation du groupe de ressources pour le reseau
resource "azurerm_resource_group" "network_rg" {
  name     = var.network_rg_name
  location = var.location
}

# creation du reseau virtuel pour le backend
resource "azurerm_virtual_network" "backend_vnet" {
  name                = var.backend_vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.network_rg.name
  address_space       = ["10.2.0.0/16"]
  depends_on = [ azurerm_resource_group.network_rg ]
}

# creation du sous-reseau pour le serveur backend
resource "azurerm_subnet" "backend_subnet" {
  name                 = "backend-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.backend_vnet.name
  address_prefixes     = ["10.2.1.0/24"]
  depends_on = [ azurerm_virtual_network.backend_vnet , azurerm_resource_group.network_rg ]
}

# creation de la carte reseau pour le serveur backend
resource "azurerm_network_interface" "backend_nic" {
  name                = "backend-nic"
  location            = azurerm_resource_group.backend_rg.location
  resource_group_name = azurerm_resource_group.backend_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.backend_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [ azurerm_subnet.backend_subnet , azurerm_resource_group.backend_rg ]
}

# Créer la machine virtuelle pour le backend
resource "azurerm_linux_virtual_machine" "backend_vm" {
  name                  = "sigl-backend-server"
  location              = azurerm_resource_group.backend_rg.location
  resource_group_name   = azurerm_resource_group.backend_rg.name
  network_interface_ids = [azurerm_network_interface.backend_nic.id]
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

  computer_name  = "sigl-backend-server"
  admin_username = "sigladmin"

  admin_ssh_key {
    username   = "sigladmin"
    public_key = tls_private_key.backend_ssh_key.public_key_openssh # geré da le fichier ssh.tf
  }

  provision_vm_agent = true
  depends_on = [ azurerm_network_interface.backend_nic ]
}

# creation du nsg pour le backend
resource "azurerm_network_security_group" "backend_nsg" {
  name                = "backend-nsg"
  location            = azurerm_resource_group.backend_rg.location
  resource_group_name = azurerm_resource_group.backend_rg.name
  depends_on = [ azurerm_resource_group.backend_rg ]
}

# creation de la regle de pare-feu pour le backend en ssh
resource "azurerm_network_security_rule" "backend_ssh" {
  name                        = "backend-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.3.1.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.backend_rg.name
  network_security_group_name = azurerm_network_security_group.backend_nsg.name
}

# creation de la regle de pare-feu pour le backend en http
resource "azurerm_network_security_rule" "backend_http" {
  name                        = "backend-http"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5600"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.backend_rg.name
  network_security_group_name = azurerm_network_security_group.backend_nsg.name
}

# association du nsg à la carte reseau
resource "azurerm_subnet_network_security_group_association" "backend_nsg_association" {
  subnet_id                 = azurerm_subnet.backend_subnet.id
  network_security_group_id = azurerm_network_security_group.backend_nsg.id
}



