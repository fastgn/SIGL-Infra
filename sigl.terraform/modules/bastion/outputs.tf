# Sorties du module bastion
output "vm_id" {
  value = azurerm_linux_virtual_machine.bastion_vm.id
}

output "vm_public_ip" {
  value = azurerm_network_interface.bastion_nic.ip_configuration[0].private_ip_address
}

output "bastion_public_key" {
  value = tls_private_key.bastion_ssh_key.public_key_openssh
}

output "bastion_private_key" {
  value     = tls_private_key.bastion_ssh_key.private_key_pem
  sensitive = true
}

output "bastion_resource_group_name" {
  value = azurerm_resource_group.bastion_rg.name
  description = "Nom du groupe de ressources pour le bastion."
}

output "bastion_vnet_name" {
  value = azurerm_virtual_network.bastion_vnet.name
  description = "Nom du réseau virtuel pour le bastion."
}

output "bastion_subnet_name" {
  value = azurerm_subnet.bastion_subnet.name
  description = "Nom du sous-réseau pour le serveur bastion."
}

output "bastion_nic_name" {
  value = azurerm_network_interface.bastion_nic.name
  description = "Nom de la carte réseau pour le serveur bastion."
}

output "bastion_vm_name" {
  value = azurerm_linux_virtual_machine.bastion_vm.name
  description = "Nom de la machine virtuelle pour le bastion."
}
