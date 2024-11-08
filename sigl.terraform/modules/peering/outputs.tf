output "frontend_vnet_id" {
  value = data.azurerm_virtual_network.frontend_vnet.id
}

output "backend_vnet_id" {
  value = data.azurerm_virtual_network.backend_vnet.id
}

output "bastion_vnet_id" {
  value = data.azurerm_virtual_network.bastion_vnet.id
}
