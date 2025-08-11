terraform {
  required_version = ">= 1.0.0"
  # TODO: Declare required providers here
}

# TODO: Configure providers (e.g., azurerm)

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    port = {
      source  = "port-labs/port-labs"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "port" {}
