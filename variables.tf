# Shared variable declarations

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group" {
  description = "Resource group"
  type        = string
}