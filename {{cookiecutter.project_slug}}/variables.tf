variable "azure_subscription_id" {
  type = string
}

variable "azure_tenant_id" {
  type = string
}

variable "port_client_id" {
  type = string
}

variable "port_client_secret" {
  type = string
  sensitive = true
}

# Backend configuration variables
variable "backend_rg" {
  type = string
}

variable "backend_storage_account" {
  type = string
}

variable "backend_container" {
  type = string
}

variable "backend_key" {
  type = string
}
