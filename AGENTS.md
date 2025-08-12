# AGENTS

- **Run Terraform checks** from within the templated project directory `{{cookiecutter.project_slug}}`:
  ```bash
  terraform fmt -check
  terraform init -backend=false
  terraform validate
  ```
  Remove the generated `.terraform` directory afterward.
- **Workflow files**: wrap `${{ }}` expressions in `{% raw %}` and `{% endraw %}` to prevent Cookiecutter from rendering them.
- **Template structure**: keep all project files inside `{{cookiecutter.project_slug}}` and use the `project_slug` variable.

These instructions apply to the entire repository.

## Additional Testing & Linting


To test changes to the template:

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
