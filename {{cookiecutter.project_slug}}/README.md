# {{ cookiecutter.project_slug }}

This repository was generated using the Terraform service cookiecutter template.

## Required GitHub Secrets

The workflow requires the following repository secrets to authenticate with Azure and Port and to configure the Terraform backend:

- `AZURE_CLIENT_ID` - Azure AD application client ID used for OIDC.
- `AZURE_TENANT_ID` - Azure AD tenant ID.
- `AZURE_SUBSCRIPTION_ID` - Azure subscription for deploying resources.
- `PORT_CLIENT_ID` - Client ID for Port provider.
- `PORT_CLIENT_SECRET` - Client secret for Port provider.
- `BACKEND_RG` - Name of the resource group containing the backend storage account.
- `BACKEND_STORAGE_ACCOUNT` - Name of the storage account for the Terraform state.
- `BACKEND_CONTAINER` - Storage account container for the state file.
- `BACKEND_KEY` - Key (blob name) of the state file.

Ensure these secrets are defined in the repository settings before running the workflow.
