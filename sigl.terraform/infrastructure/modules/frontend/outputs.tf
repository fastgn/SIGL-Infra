# output.tf

# Output du groupe de ressources du frontend
output "frontend_resource_group_name" {
  description = "Le nom du groupe de ressources pour le frontend"
  value       = azurerm_resource_group.frontend_rg.name
}

# Output de l'interface réseau du frontend
output "frontend_nic_id" {
  description = "L'ID de l'interface réseau pour le frontend"
  value       = azurerm_network_interface.frontend_nic[0].id
}

# Output de la machine virtuelle frontend
output "frontend_vm_name" {
  description = "Le nom de la machine virtuelle pour le frontend"
  value       = azurerm_linux_virtual_machine.frontend_vm.name
}

# Output de l'ID de la machine virtuelle frontend
output "vm_ids" {
  description = "Liste des IDs des VMs frontend"
  value       = azurerm_linux_virtual_machine.frontend_vm.*.id
}
