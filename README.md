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
   - `description` – short summary of the service.
   - `port_service_name` – display name for the service in Port.
   - `port_service_identifier` – unique service identifier in Port.
   - `port_cost_centre` – cost centre or billing code.
   - `port_owning_team` – team responsible for the service.
   - `port_owning_team_identifier` – unique identifier for the owning team in Port.

`project_name` is set to `port_service_name`, and `project_slug` uses the repository portion of `port_repository_identifier`.

These Port-related values surface in `.provisioning/repository-config.yml` during repository provisioning.

The template will produce a new directory named after the repository from `port_repository_identifier` containing a starter Terraform configuration.

## What's Included

- `cookiecutter.json` – template variables.
- `{{cookiecutter.project_slug}}/` – full Terraform project ready to customize, including a GitHub Actions workflow.
- `.provisioning/` – repository provisioning config and docs; `repository-config.yml` is the single source of truth for initial repository settings.

## Developing the Template


Changes to the template should ensure Terraform configuration remains valid and pass all linting and static analysis checks. Run from within the templated project directory:

```bash
cd {{cookiecutter.project_slug}}
terraform fmt -check
terraform init -backend=false
terraform validate
cd ..
```

### Additional Testing & Linting

To test changes to the template, you should:

1. Install Cookiecutter if you haven't already, and use it to generate a new project in a temporary directory (e.g., `/tmp/test-template`):

   ```bash
   pip install --user cookiecutter
   cookiecutter . --output-dir /tmp/test-template
   cd /tmp/test-template/<your-project-slug>
   ```

2. Install all linting tools in a temporary folder (do not pollute your global environment):

   ```bash
   TMP_LINT_DIR="/tmp/test-template-linters"
   mkdir -p "$TMP_LINT_DIR"
   python3 -m venv "$TMP_LINT_DIR/venv"
   source "$TMP_LINT_DIR/venv/bin/activate"
   pip install pyflakes
   sudo apt-get update && sudo apt-get install -y shellcheck
   curl -sSfL https://raw.githubusercontent.com/rhysd/actionlint/main/scripts/download-actionlint.bash | bash -s -- -b "$TMP_LINT_DIR"
   curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash -s -- -b "$TMP_LINT_DIR"
   export PATH="$TMP_LINT_DIR:$PATH"
   ```

3. Run the linting tools from within the generated project directory:

   ```bash
   actionlint
   tflint --format=compact
   # Optionally run pyflakes and shellcheck on relevant files
   pyflakes .
   find . -name '*.sh' -exec shellcheck {} +
   ```

Resolve all issues reported with severity warning or above before merging.
