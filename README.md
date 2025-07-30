# Terraform Service Cookiecutter

This repository contains a cookiecutter template for creating Terraform service projects with Azure and Port provider support.

Run `cookiecutter` against this template to scaffold a new project:

```bash
cookiecutter https://github.com/your-org/terraform-service-template.git
```

The generated project will include a GitHub Actions workflow that authenticates to Azure using OIDC and deploys Terraform to the specified environment.
