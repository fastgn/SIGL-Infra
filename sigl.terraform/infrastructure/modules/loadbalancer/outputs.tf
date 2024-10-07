output "backend_pool_id" {
  description = "ID du backend pool du load balancer"
  value       = azurerm_lb_backend_address_pool.backend_pool.id
}

output "public_ip" {
  description = "Adresse IP publique du Load Balancer"
  value       = azurerm_public_ip.public_ip.ip_address
}
