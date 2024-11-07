# module de resources pour le frontend

# creation du groupe de ressources pour le frontend
resource "azurerm_resource_group" "frontend_rg" {
  name     = var.frontend_rg_name
  location = var.location
}

# creation du groupe de ressources pour le reseau
resource "azurerm_resource_group" "network_rg" {
  name     = var.network_rg_name
  location = var.location
}

# creation du reseau virtuel pour le frontend
resource "azurerm_virtual_network" "frontend_vnet" {
  name                = "frontend-vnet"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
  address_space       = ["10.1.0.0/16"]
  depends_on = [ azurerm_resource_group.network_rg ]
}

# creation du sous-reseau pour le serveur frontend
resource "azurerm_subnet" "frontend_subnet" {
  name                 = "frontend-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.frontend_vnet.name
  address_prefixes     = ["10.1.1.0/24"]
  depends_on = [ azurerm_virtual_network.frontend_vnet ]
}

# creation de la carte reseau pour le serveur frontend
resource "azurerm_network_interface" "frontend_nic" {
  name                = "frontend-nic"
  location            = azurerm_resource_group.frontend_rg.location
  resource_group_name = azurerm_resource_group.frontend_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.frontend_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Créer la machine virtuelle pour le frontend
resource "azurerm_linux_virtual_machine" "frontend_vm" {
  name                  = "sigl-frontend-server"
  location              = azurerm_resource_group.frontend_rg.location
  resource_group_name   = azurerm_resource_group.frontend_rg.name
  network_interface_ids = [azurerm_network_interface.frontend_nic.id]
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

  computer_name  = "sigl-frontend-server"
  admin_username = "sigladmin"

  admin_ssh_key {
    username   = "sigladmin"
    public_key = tls_private_key.frontend_ssh_key.public_key_openssh # geré da le fichier ssh.tf
  }

  provision_vm_agent = true
}


# creation du groupe de ressources pour le load balancer
resource "azurerm_resource_group" "load_balancer_rg" {
  name     = "load-balancer-rg"
  location = var.location
}

# creation de l'ip publique pour le load balancer
resource "azurerm_public_ip" "lb_public_ip" {
  name                = "load-balancer-public-ip"
  location            = azurerm_resource_group.load_balancer_rg.location
  resource_group_name = azurerm_resource_group.load_balancer_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version =  "IPv4"
  domain_name_label = "sigl-web-app"
}

# creation du load balancer
resource "azurerm_lb" "frontend_lb" {
  name                = "frontend-lb"
  location            = azurerm_resource_group.load_balancer_rg.location
  resource_group_name = azurerm_resource_group.load_balancer_rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

# creation de la regle de load balancing HTTP
resource "azurerm_lb_rule" "http_lb_rule" {
  loadbalancer_id            = azurerm_lb.frontend_lb.id
  name                       = "HTTPRule"
  protocol                   = "Tcp"
  frontend_port              = 80
  backend_port               = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids   = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                   = azurerm_lb_probe.http_probe.id
}

# Création de la règle de load balancing pour HTTPS
resource "azurerm_lb_rule" "https_lb_rule" {
  loadbalancer_id                     = azurerm_lb.frontend_lb.id
  name                                = "HTTPSRule"
  protocol                            = "Tcp"
  frontend_port                       = 443
  backend_port                        = 443
  frontend_ip_configuration_name      = "PublicIPAddress"
  backend_address_pool_ids            = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                            = azurerm_lb_probe.https_probe.id
}

# creation de la sonde de load balancing HTTP
resource "azurerm_lb_probe" "http_probe" {
  name                = "http-probe"
  loadbalancer_id      = azurerm_lb.frontend_lb.id
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 15
  number_of_probes    = 4
}

# Création de la sonde de load balancing pour HTTPS
resource "azurerm_lb_probe" "https_probe" {
  name                = "https-probe"
  loadbalancer_id    = azurerm_lb.frontend_lb.id
  protocol           = "Https"  
  port               = 443
  request_path       = "/"  
  interval_in_seconds = 15   
  number_of_probes    = 4   
}

# creation du pool d'adresses pour le load balancer
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.frontend_lb.id
  name           = "backend-pool"
}

# association de la machine virtuelle au pool d'adresses
resource "azurerm_network_interface_backend_address_pool_association" "nic_pool_association" {
  network_interface_id    = azurerm_network_interface.frontend_nic.id
  ip_configuration_name    = azurerm_network_interface.frontend_nic.ip_configuration.0.name
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
  depends_on = [ azurerm_lb.frontend_lb, azurerm_network_interface.frontend_nic, azurerm_lb_backend_address_pool.backend_pool ]
}

# creation du regle de securite pour le load balancer
resource "azurerm_network_security_group" "frontend_nsg" {
  name                = "frontend-nsg"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
}

# creation de la regle de securite pour le frontend http
resource "azurerm_network_security_rule" "frontend_nsg_rule" {
  name                        = "frontend-nsg-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.network_rg.name
  network_security_group_name = azurerm_network_security_group.frontend_nsg.name
}

# creation de la regle de securite pour le frontend https
resource "azurerm_network_security_rule" "frontend_nsg_rule_https" {
  name                        = "frontend-nsg-rule-https"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.network_rg.name
  network_security_group_name = azurerm_network_security_group.frontend_nsg.name
}

# creation de la regle de securite pour le frontend ssh
resource "azurerm_network_security_rule" "frontend_nsg_rule_ssh" {
  name                        = "frontend-nsg-rule-ssh"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.3.1.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.network_rg.name
  network_security_group_name = azurerm_network_security_group.frontend_nsg.name
}

# association du NSG à la sous-reseau du frontend
resource "azurerm_subnet_network_security_group_association" "frontend_nsg_association" {
  subnet_id                 = azurerm_subnet.frontend_subnet.id
  network_security_group_id = azurerm_network_security_group.frontend_nsg.id
}

#