# Shared variable declarations

# tflint-ignore: terraform_unused_declarations
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

# tflint-ignore: terraform_unused_declarations
variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group" {
  description = "Resource group"
  type        = string
}
