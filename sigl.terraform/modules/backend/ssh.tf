# Fournisseur TLS pour générer des clés SS

# Générer une paire de clés SSH
resource "tls_private_key" "backend_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#ecrire la clé privée dans un fichier
resource "local_file" "private_backend_ssh_key" {
  content  = tls_private_key.backend_ssh_key.private_key_pem
  filename = "${path.module}/backend_private_ssh.key"
}

# ecrire la clé publique dans un fichier
resource "local_file" "public_backend_ssh_key" {
  content  = tls_private_key.backend_ssh_key.public_key_openssh
  filename = "${path.module}/backend_public_ssh.key"
}
# Sorties pour afficher la clé publique
output "public_key" {
  value = tls_private_key.backend_ssh_key.public_key_openssh
}

# Sorties pour afficher la clé privée
output "private_key" {
  value     = tls_private_key.backend_ssh_key.private_key_pem
  sensitive = true
}
