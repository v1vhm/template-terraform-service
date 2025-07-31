terraform {
  required_version = ">= {{ cookiecutter.terraform_version }}"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    port = {
      source  = "port-labs/port"
      version = "~> 1.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
}

provider "port" {
  client_id     = var.port_client_id
  client_secret = var.port_client_secret
}
