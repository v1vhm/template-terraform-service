terraform {
  required_version = ">= 1.0.0"
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
}

provider "port" {}
