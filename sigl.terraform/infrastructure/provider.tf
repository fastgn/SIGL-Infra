  # Provider pour Site A (compte Azure A)
  provider "azurerm" {
    alias           = "frontend"  # Donne un alias à ce provider
    
    subscription_id = var.subscription_id_frontend
    client_id       = var.client_id_frontend
    client_secret   = var.client_secret_frontend
    tenant_id       = var.tenant_id_frontend
  }

  # Provider pour Site B (compte Azure B)
  provider "azurerm" {
    alias           = "backend"  # Donne un alias à ce provider

    subscription_id = var.subscription_id_backend
    client_id       = var.client_id_backend
    client_secret   = var.client_secret_backend
    tenant_id       = var.tenant_id_backend
  }
