variable "lb_name" {
  description = "The name of the load balancer"
  type        = string
}

variable "location" {
  description = "The Azure region where the load balancer will be deployed"
  type        = string
  default     = "francecentral"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "frontend_vm_ids" {
  description = "List of IDs of the frontend VMs for backend pool"
  type        = list(string)
}
