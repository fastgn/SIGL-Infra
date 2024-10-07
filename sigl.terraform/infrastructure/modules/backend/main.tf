

# Définition des groupes de ressources du backend
resource "azurerm_resource_group" "backend_rg" {
  name     = "backend-rg"
  location = "francecentral"
}

resource "azurerm_virtual_network" "backend_vnet" {
  name                = "backend-vnet"
  address_space       = ["10.0.1.0/24"]
  location            = azurerm_resource_group.backend_rg.location
  resource_group_name = azurerm_resource_group.backend_rg.name
}

resource "azurerm_subnet" "backend_subnet" {
  name                 = "backend-subnet"
  resource_group_name  = azurerm_resource_group.backend_rg.name
  virtual_network_name = azurerm_virtual_network.backend_vnet.name
  address_prefixes     = ["10.0.1.0/25"]
}

resource "azurerm_network_interface" "backend_nic" {
  count               = 1  
  name                = "backend-nic-${count.index}"
  location            = azurerm_resource_group.backend_rg.location
  resource_group_name = azurerm_resource_group.backend_rg.name

  ip_configuration {
    name                          = "backend-ip-config"
    subnet_id                    = azurerm_subnet.backend_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Creation de la machine linux
resource "azurerm_linux_virtual_machine" "backend_vm" {
  name                = "sigl-backend-server"
  resource_group_name = azurerm_resource_group.backend_rg.name
  location            = var.location
  size                = "Standard_B2ats_v2"
  admin_username      = "sigladmin"
  network_interface_ids = [
    azurerm_network_interface.backend_nic.id,
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
