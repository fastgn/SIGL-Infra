#!/bin/bash

# Script de déploiement pour l'infrastructure Azure

# Vérifiez que Terraform est installé
if ! command -v terraform &> /dev/null
then
    echo "Terraform n'est pas installé. Veuillez l'installer avant de continuer."
    exit 1
fi

# Définir des variables pour les comptes Azure
SUBSCRIPTION_ID_FRONTEND="db6867b2-7887-4472-a2c5-a1a1287fc18d "
CLIENT_ID_FRONTEND="<VOTRE_CLIENT_ID_FRONTEND>"
CLIENT_SECRET_FRONTEND="<VOTRE_CLIENT_SECRET_FRONTEND>"
TENANT_ID_FRONTEND="4d7ad159-1265-437a-b9f6-2946247d5bf9"

SUBSCRIPTION_ID_BACKEND="<VOTRE_SUBSCRIPTION_ID_BACKEND>"
CLIENT_ID_BACKEND="<VOTRE_CLIENT_ID_BACKEND>"
CLIENT_SECRET_BACKEND="<VOTRE_CLIENT_SECRET_BACKEND>"
TENANT_ID_BACKEND="<VOTRE_TENANT_ID_BACKEND>"

# Connexion au compte Azure site frontend
echo "Connexion à Azure site frontend..."
az login --service-principal -u $CLIENT_ID_FRONTEND -p $CLIENT_SECRET_FRONTEND --tenant $TENANT_ID_FRONTEND
az account set --subscription $SUBSCRIPTION_ID_FRONTEND

# Initialiser Terraform pour le site frontend
echo "Initialisation de Terraform pour le site frontend..."
terraform init

# Valider la configuration Terraform pour le site frontend
echo "Validation de la configuration Terraform pour le site frontend..."
terraform validate

# Déployer l'infrastructure pour le site frontend
echo "Déploiement de l'infrastructure pour le site frontend..."
terraform apply -auto-approve

# Connexion au compte Azure site backend
echo "Connexion à Azure site backend..."
az login --service-principal -u $CLIENT_ID_BACKEND -p $CLIENT_SECRET_BACKEND --tenant $TENANT_ID_BACKEND
az account set --subscription $SUBSCRIPTION_ID_BACKEND

# Initialiser Terraform pour le site backend
echo "Initialisation de Terraform pour le site backend..."
terraform init

# Valider la configuration Terraform pour le site backend
echo "Validation de la configuration Terraform pour le site backend..."
terraform validate

# Déployer l'infrastructure pour le site backend
echo "Déploiement de l'infrastructure pour le site backend..."
terraform apply -auto-approve

echo "Déploiement terminé avec succès."
