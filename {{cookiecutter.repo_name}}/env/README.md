# Environment Variable Files

Store environment-specific Terraform variable definitions in this directory.

Each environment should live in its own subdirectory (e.g., `dev/`, `staging/`, `prod/`). Inside that directory, create:

- `<environment>.tfvars` containing:

```
environment    = "<environment name>"
location       = "<location>"
resource_group = "<resource group name>"
```

These `.tfvars` files can include additional variables as needed. 

- `<environment>.state.config` providing backend settings for the `azurerm` remote state:

```
resource_group_name  = "<resource-group>"
storage_account_name = "<storage-account>"
container_name       = "<blob-container>"
key                  = "<state-file-name>"
```

