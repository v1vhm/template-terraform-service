# Environment Variable Files

Store environment-specific Terraform variable definitions in this directory.

Create a separate `.tfvars` file for each environment (e.g., `dev.tfvars`, `staging.tfvars`, `prod.tfvars`).
These files typically define values such as the environment name, region, and other settings.

Each environment must also provide a corresponding `<environment>.state.config` file. This file supplies
the backend settings for the `azurerm` remote state and is referenced by the workflow. Its contents
should define the following keys:

```
resource_group_name  = "<resource-group>"
storage_account_name = "<storage-account>"
container_name       = "<blob-container>"
key                  = "<state-file-name>"
```
These `*.state.config` files must be created for each environment but kept out of source control,
as they may contain sensitive backend details.

