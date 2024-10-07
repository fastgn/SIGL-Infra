variable "vnet_id" {
  description = "The ID of the VNet where the frontend VMs will be deployed."
  type        = string
}

variable "public_ip" {
  description = "The public IP address of the Load Balancer."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources."
  type        = string
  default     = "francecentral"
}

variable "load_balancer_backend_pool_id" {
  description = "ID of the backend address pool for the frontend VMs"
  type        = string
}
