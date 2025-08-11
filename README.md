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


Changes to the template should ensure Terraform configuration remains valid and pass all linting and static analysis checks. Run from within the templated project directory:

```bash
cd {{cookiecutter.repo_name}}
terraform fmt -check
terraform init -backend=false
terraform validate
cd ..
```

### Additional Testing & Linting

Before submitting changes, ensure the following tools are installed and run:

```bash
# Install linters
pip install pyflakes
sudo apt-get update && sudo apt-get install -y shellcheck
curl -sSfL https://raw.githubusercontent.com/rhysd/actionlint/main/scripts/download-actionlint.bash | bash
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Run actionlint (with shellcheck and pyflakes available)
actionlint

# Run tflint and resolve all issues with severity warning and above
tflint --format=compact
```

Resolve all issues reported with severity warning or above before merging.
