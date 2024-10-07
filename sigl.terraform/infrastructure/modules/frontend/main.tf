

# Définition des groupes de ressources du frontend
resource "azurerm_resource_group" "frontend_rg" {
  name     = "frontend-rg"
  location = "francecentral"
}
# Association de l'interface réseau au backend pool du Load Balancer
resource "azurerm_network_interface_backend_address_pool_association" "frontend_lb_association" {
  count                = 1
  network_interface_id = azurerm_network_interface.frontend_nic[count.index].id
  ip_configuration_name = "frontend-ip-config"
  backend_address_pool_id = var.load_balancer_backend_pool_id
}

resource "azurerm_network_interface" "frontend_nic" {
  count               = 1  
  name                = "frontend-nic-${count.index}"
  location            = azurerm_resource_group.frontend_rg.location
  resource_group_name = azurerm_resource_group.frontend_rg.name

  ip_configuration {
    name                          = "frontend-ip-config"
    subnet_id                    = azurerm_subnet.frontend_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Creation de la machine linux
resource "azurerm_linux_virtual_machine" "frontend_vm" {
  name                = "sigl-frontend-server"
  resource_group_name = azurerm_resource_group.frontend_rg.name
  location            = var.location
  size                = "Standard_B2ats_v2"
  admin_username      = "sigladmin"
  network_interface_ids = [
    azurerm_network_interface.frontend_nic.id,
  ]

  admin_ssh_key {
    username   = "sigladmin"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22.04-LTS"
    version   = "latest"
  }
}

