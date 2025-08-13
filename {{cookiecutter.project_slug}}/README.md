# {{ cookiecutter.project_name }}

{{ cookiecutter.description }}

It includes core configuration files, placeholders for environment variable sets and reusable modules, and CI/CD workflow scaffolding.

## Port Metadata

This project captures several Port-related attributes during generation:

- `{{ cookiecutter.port_service_name }}` – display name for the service in Port.
- `{{ cookiecutter.port_service_identifier }}` – unique identifier for the service.
- `{{ cookiecutter.port_repository_identifier }}` – Port entity identifier for this repository.
- `{{ cookiecutter.port_cost_centre }}` – cost centre or billing code.
- `{{ cookiecutter.port_owning_team }}` – owning team name.
- `{{ cookiecutter.port_owning_team_identifier }}` – unique identifier for the owning team.

These values surface in `.provisioning/repository-config.yml` when provisioning the repository.

## Repository Layout

- **main.tf** – Entry point for resources and module calls.
- **variables.tf** – Shared variable declarations.
- **outputs.tf** – Shared output values.
- **providers.tf** – Terraform version and required providers (AzureRM and Port).
- **backend.tf** – Template for remote state configuration.
- **env/** – Placeholder for environment-specific variable directories (see `env/README.md`).
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
