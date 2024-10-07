# outputs.tf

# Output du Load Balancer
output "public_ip_lb" {
  description = "Adresse IP publique du Load Balancer"
  value       = module.load_balancer.public_ip
}

# Output du Frontend
output "frontend_vm_ip" {
  description = "Adresse IP privée de la VM frontend"
  value       = module.frontend.vm_private_ip
}

# Output du Backend
output "backend_vm_ip" {
  description = "Adresse IP privée de la VM backend"
  value       = module.backend.vm_private_ip
}

# Output de la Base de Données PostgreSQL
output "postgresql_server_name" {
  description = "Nom du serveur PostgreSQL"
  value       = module.database.postgresql_server_name
}

# Output du compte de stockage
output "storage_account_name" {
  description = "Nom du compte de stockage"
  value       = module.storage.storage_account_name
}
