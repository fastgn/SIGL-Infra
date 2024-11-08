# Sorties du module frontend
output "vm_id" {
  value = azurerm_linux_virtual_machine.frontend_vm.id
}

output "frontend_public_key" {
  value = tls_private_key.frontend_ssh_key.public_key_openssh
}

output "frontend_private_key" {
  value     = tls_private_key.frontend_ssh_key.private_key_pem
  sensitive = true
}

output "frontend_resource_group_name" {
  value = azurerm_resource_group.frontend_rg.name
  description = "Nom du groupe de ressources pour le frontend."
}

output "network_resource_group_name" {
  value = azurerm_resource_group.network_rg.name
  description = "Nom du groupe de ressources pour le réseau."
}

output "frontend_vnet_name" {
  value = azurerm_virtual_network.frontend_vnet.name
  description = "Nom du réseau virtuel pour le frontend."
}

output "frontend_subnet_name" {
  value = azurerm_subnet.frontend_subnet.name
  description = "Nom du sous-réseau pour le serveur frontend."
}

output "frontend_nic_name" {
  value = azurerm_network_interface.frontend_nic.name
  description = "Nom de la carte réseau pour le serveur frontend."
}

output "frontend_vm_name" {
  value = azurerm_linux_virtual_machine.frontend_vm.name
  description = "Nom de la machine virtuelle pour le frontend."
}

output "load_balancer_name" {
  value = azurerm_lb.frontend_lb.name
  description = "Nom du load balancer."
}

output "public_ip_address" {
  value = azurerm_public_ip.lb_public_ip.ip_address
  description = "Adresse IP publique du load balancer."
}

output "backend_address_pool_name" {
  value = azurerm_lb_backend_address_pool.backend_pool.name
  description = "Nom du pool d'adresses backend du load balancer."
}
