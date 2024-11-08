#!/bin/bash

# Script d'installation et de configuration de CrowdSec pour un serveur Apache

# Mettre à jour le système
echo "Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

# Installer les dépendances nécessaires
echo "Installation des dépendances nécessaires..."
sudo apt install -y curl apt-transport-https

# Ajouter le dépôt de CrowdSec
echo "Ajout du dépôt CrowdSec..."
echo "deb https://packages.crowdsec.net/deb/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/crowdsec.list

# Ajouter la clé GPG pour le dépôt
echo "Ajout de la clé GPG..."
curl -s https://packages.crowdsec.net/crowdsec.gpg.key | sudo apt-key add -

# Installer CrowdSec
echo "Installation de CrowdSec..."
sudo apt update
sudo apt install -y crowdsec

# Démarrer et activer le service CrowdSec
echo "Démarrage du service CrowdSec..."
sudo systemctl start crowdsec
sudo systemctl enable crowdsec

# Installer le bouncer pour Apache
echo "Installation du bouncer CrowdSec pour Apache..."
sudo apt install -y crowdsec-firewall-bouncer

# Configurer CrowdSec pour Apache
echo "Configuration de CrowdSec pour Apache..."
echo 'bouncers:
  - name: "crowdsec-firewall-bouncer"
    type: "firewall"
' | sudo tee /etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml

# Redémarrer le service CrowdSec pour appliquer les modifications
echo "Redémarrage du service CrowdSec..."
sudo systemctl restart crowdsec

# Installer les règles d'attaque de base
echo "Installation des règles d'attaque de base..."
sudo cscli hub install crowdsecurity/apache-badbots
sudo cscli hub install crowdsecurity/apache-crawl
sudo cscli hub install crowdsecurity/apache-dos
sudo cscli hub install crowdsecurity/apache-tor
sudo cscli hub install crowdsecurity/apache-sshd

# Démarrer le bouncer
echo "Démarrage du bouncer CrowdSec..."
sudo systemctl start crowdsec-firewall-bouncer
sudo systemctl enable crowdsec-firewall-bouncer

# Afficher le statut de CrowdSec et du bouncer
echo "Statut de CrowdSec et du bouncer :"
sudo systemctl status crowdsec
sudo systemctl status crowdsec-firewall-bouncer

echo "CrowdSec a été installé et configuré avec succès !"
