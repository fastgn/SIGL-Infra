# Sorties du module backend
output "vm_id" {
  value = azurerm_linux_virtual_machine.backend_vm.id
}

output "vm_public_ip" {
  value = azurerm_network_interface.backend_nic.ip_configuration[0].private_ip_address
}

output "backend_public_key" {
  value = tls_private_key.backend_ssh_key.public_key_openssh
}

output "backend_private_key" {
  value     = tls_private_key.backend_ssh_key.private_key_pem
  sensitive = true
}

output "backend_resource_group_name" {
  value = azurerm_resource_group.backend_rg.name
  description = "Nom du groupe de ressources pour le backend."
}


output "backend_vnet_name" {
  value = azurerm_virtual_network.backend_vnet.name
  description = "Nom du réseau virtuel pour le backend."
}

output "backend_subnet_name" {
  value = azurerm_subnet.backend_subnet.name
  description = "Nom du sous-réseau pour le serveur backend."
}

output "backend_nic_name" {
  value = azurerm_network_interface.backend_nic.name
  description = "Nom de la carte réseau pour le serveur backend."
}

output "backend_vm_name" {
  value = azurerm_linux_virtual_machine.backend_vm.name
  description = "Nom de la machine virtuelle pour le backend."
}
