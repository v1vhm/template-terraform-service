# AGENTS

- **Run Terraform checks** from within the templated project directory `{{cookiecutter.repo_name}}`:
  ```bash
  terraform fmt -check
  terraform init -backend=false
  terraform validate
  ```
  Remove the generated `.terraform` directory afterward.
- **Workflow files**: wrap `${{ }}` expressions in `{% raw %}` and `{% endraw %}` to prevent Cookiecutter from rendering them.
- **Template structure**: keep all project files inside `{{cookiecutter.repo_name}}` and use the `repo_name` variable instead of `project_slug`.

These instructions apply to the entire repository.

## Additional Testing & Linting

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
