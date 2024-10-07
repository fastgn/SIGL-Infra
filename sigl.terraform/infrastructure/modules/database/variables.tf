variable "resource_group_name" {
  description = "The name of the resource group in which to create the PostgreSQL Flexible Server"
  type        = string
  default     = "database-rg"
}

variable "location" {
  description = "The Azure region where the PostgreSQL Flexible Server should exist"
  type        = string
  default     = "francecentral"
}

variable  database_admin_password {
  description = "The authentication method for the PostgreSQL server"
  type        = string
  default     = "R4a682e6xgL343L3p8rUXDcjuR6pHMrG"
}

variable "database_admin_name" {
  description = "The username for the PostgreSQL server administrator"
  type        = string
  default     = "pgadmin"
  
}
