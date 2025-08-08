# Terraform Service Template

This repository provides a baseline structure for managing multiple Azure environments with Terraform. It includes core configuration files, environment-specific variable sets, and placeholders for reusable modules and CI/CD workflows.

## Repository Layout

- **main.tf** – Entry point for resources and module calls.
- **variables.tf** – Shared variable declarations.
- **outputs.tf** – Shared output values.
- **providers.tf** – Terraform version and provider requirements.
- **backend.tf** – Template for remote state configuration.
- **env/** – Environment-specific variable files (`dev.tfvars`, `staging.tfvars`, `prod.tfvars`).
- **modules/** – Local modules such as `network` and `storage`.
- **.github/workflows/** – Placeholder GitHub Actions workflow for plan and apply via pull requests.

Update these files with real infrastructure definitions as the project evolves.
