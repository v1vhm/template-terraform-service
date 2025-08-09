# Remote state backend configuration (partial)
# Backend settings are provided via environment-specific .state.config files in env/<environment>/<environment>.state.config
terraform {
  backend "azurerm" {
    resource_group_name  = ""
    storage_account_name = ""
    container_name       = ""
    key                  = ""
  }
}
