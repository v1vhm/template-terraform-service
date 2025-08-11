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
