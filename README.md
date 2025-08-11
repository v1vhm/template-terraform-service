# Terraform Service Cookiecutter Template

This repository packages a Terraform service as a [Cookiecutter](https://cookiecutter.readthedocs.io/) template. It scaffolds a baseline for managing Azure infrastructure and includes a GitHub Actions workflow and common Terraform configuration files.

## Quickstart

1. Install Cookiecutter if you haven't:

   ```bash
   pip install cookiecutter
   ```

2. Generate a new project:

   ```bash
   cookiecutter gh:ORG_NAME/template-terraform-service
   ```

3. Follow the prompts for:
   - `project_name` – human readable name of your service.
   - `repo_name` – repository folder name derived from `project_name`.
   - `description` – short summary of the service.

The template will produce a new directory named after `repo_name` containing a starter Terraform configuration.

## What's Included

- `cookiecutter.json` – template variables.
- `{{cookiecutter.repo_name}}/` – full Terraform project ready to customize, including a GitHub Actions workflow.

## Developing the Template

Changes to the template should ensure Terraform configuration remains valid. Run from within the templated project directory:

```bash
cd {{cookiecutter.repo_name}}
terraform fmt -check
terraform init -backend=false
terraform validate
cd ..
```
