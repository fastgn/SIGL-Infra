# Define a Public Load Balancer resource
resource "azurerm_lb" "public_lb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  frontend_ip_configuration {
    name                 = "PublicIPConfig"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

# Create a Public IP for the Load Balancer
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.lb_name}-publicip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Define a Load Balancer rule (for HTTP)
resource "azurerm_lb_rule" "http_lb_rule" {
  loadbalancer_id            = azurerm_lb.public_lb.id
  name                       = "HTTPRule"
  protocol                   = "Tcp"
  frontend_port              = 80
  backend_port               = 80
  frontend_ip_configuration_name = "PublicIPConfig"
  backend_address_pool_ids   = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                   = azurerm_lb_probe.http_probe.id
}

# Backend pool for VMs
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id   = azurerm_lb.public_lb.id
  name              = "backend-pool"
}

# Define a health probe
resource "azurerm_lb_probe" "http_probe" {
  loadbalancer_id = azurerm_lb.public_lb.id
  name            = "http_probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
  interval_in_seconds = 5
  number_of_probes = 2
}


