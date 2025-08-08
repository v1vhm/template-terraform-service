# Terraform Service Template

This repository provides a baseline structure for managing Azure infrastructure with Terraform and Port. It includes core configuration files, placeholders for environment variable sets and reusable modules, and CI/CD workflow scaffolding.

## Repository Layout

- **main.tf** – Entry point for resources and module calls.
- **variables.tf** – Shared variable declarations.
- **outputs.tf** – Shared output values.
- **providers.tf** – Terraform version and required providers (AzureRM and Port).
- **backend.tf** – Template for remote state configuration.
- **env/** – Placeholder for environment-specific variable files (see `env/README.md`).
- **modules/** – Placeholder for reusable modules with an example module (`modules/example/`).
- **.github/workflows/** – GitHub Actions workflow for Terraform plan and apply via pull requests.
- **.github/dependabot.yml** – Dependabot configuration for Terraform and GitHub Actions updates.

Update these files with real infrastructure definitions as the project evolves.

## Required Secrets

Authentication uses GitHub OIDC; no Azure client secret is required.

- **AZURE_CLIENT_ID** – Service principal client ID for Azure login.
- **AZURE_TENANT_ID** – Azure Active Directory tenant ID.
- **AZURE_SUBSCRIPTION_ID** – Target Azure subscription ID.
- **TF_PASSPHRASE** – Used to encrypt Terraform plan files in the GitHub Actions workflow.
