# Multi-Environment Terraform Repository Boilerplate (Azure Focus)

Organizing a Terraform codebase for multiple Azure environments requires a clear structure and workflow. Below is a recommended **repository structure** and **workflow** that covers core Terraform files, environment-specific configs, local modules, a PR-driven branching strategy, and CI/CD with GitHub Actions (using the **TF-via-PR** workflow) along with GitHub Environments for secrets and approvals.

## Repository Structure Overview

```
terraform-project/
├── main.tf              # Core Terraform configuration (Azure resources, module calls)
├── variables.tf         # All input variable definitions (types, descriptions, no values)
├── outputs.tf           # Output values (shared info from your infrastructure)
├── providers.tf         # Provider settings (e.g., Azure provider, required versions)
├── backend.tf           # (Optional) Backend config template for remote state 
├── env/                 # Environment-specific variable definitions (.tfvars files)
│   ├── dev.tfvars       # Variables values for the "dev" environment
│   ├── staging.tfvars   # Variables values for the "staging" environment
│   └── prod.tfvars      # Variables values for the "prod" environment
└── modules/             # Local reusable Terraform modules
    ├── network/         # Example module (e.g., Virtual Network)
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── storage/         # Example module (e.g., Storage Account)
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

This structure is **simple and scalable** – new environments can be added by introducing a new `.tfvars` file under `env/` (or even a new folder if preferred) without duplicating core code. All environment differences (like names, regions, sizes, etc.) are captured in the tfvars, keeping the Terraform code itself environment-agnostic.

## Core Terraform Configuration (Environment-Agnostic)

The root of the repository contains the core Terraform files that define **Azure resources and modules** used in all environments. For example:

* **`main.tf`**: Contains the main configuration – this can directly define resources or, more typically, call your reusable modules to create resources. This file should be written to handle any environment by using variables (e.g. use `var.environment` in names/tags, etc.).
* **`variables.tf`**: Declares all input variables (with types, descriptions, and defaults as appropriate) that parameterize the infrastructure. Every setting that might differ per environment (location, resource names, sizes, etc.) should be a variable here. For instance, you might have `variable "location" { ... }` and `variable "environment" { ... }` declared. This ensures the **values can be supplied via tfvars** for each environment, rather than hard-coding anything.
* **`outputs.tf`**: Defines any outputs that you want to expose (e.g. resource IDs or connection strings) from the core deployment. These can be handy for feeding into other modules or just for visibility.
* **`providers.tf` / `versions.tf`**: Configures the Terraform provider(s) and required versions. For Azure, you would configure the `azurerm` provider here (and possibly use an Azure remote backend for state). Pin the provider and Terraform versions to ensure consistency.
* **`backend.tf`** (optional): If using a remote backend for state (recommended for team collaboration), you can include a partial backend config. For Azure, this might declare the backend as Azure Storage (`azurerm` backend) with placeholders or variables for resource group, storage account, container, and key. Each environment would use a different backend **state file** (e.g., key `"dev.tfstate"` for dev, `"prod.tfstate"` for prod) to keep state isolated. *(Alternative:* some teams use separate backend config files per env and supply them during init, or use Terraform Cloud workspaces. Choose a strategy that isolates state per environment.)

**No secrets or sensitive data** (like passwords, keys) are kept in these Terraform files – those will be handled via secure means (tfvars + GitHub secrets) as discussed below.

## Environment-Specific Configuration (tfvars)

All environment-specific values are stored in separate Terraform variables files under the `env/` directory, one per environment. For example, `env/dev.tfvars`, `env/staging.tfvars`, `env/prod.tfvars` each contain the values for the variables defined in `variables.tf`. This might include:

* `environment = "dev"` (name of environment used in tags/naming)
* `location    = "uksouth"` (Azure region for that environment)
* Any other settings (e.g., VM sizes, number of instances, IP ranges, etc.) specific to that environment.

By using `.tfvars` files, you cleanly separate configuration data from code. At deploy time, you specify the env file, e.g. `terraform plan -var-file="env/dev.tfvars"`. Terraform will then use the same `main.tf` and modules, but plug in these environment-specific values. This ensures **isolation** between environments (e.g., dev resources can’t accidentally affect prod) while reusing the same code. New environments can be added easily by creating a new tfvars file (and corresponding backend state) following the same pattern – this approach scales to any number of environments in a consistent way.

**Best practices:** All variables used in tfvars should be declared in `variables.tf` (to keep the code self-documenting), and never commit secrets or confidential values into tfvars (treat tfvars like code). Instead, reference secret values from a secure store or inject them via pipeline secrets (explained later). For example, if a database password is needed per environment, you might have a variable for it but set its value via an environment secret rather than writing it in the tfvars file.

## Reusable Modules Directory

The `modules/` directory contains **local Terraform modules** that encapsulate pieces of infrastructure. This prevents repetition and simplifies the main configuration. Each module is a subfolder (e.g., `modules/network`, `modules/storage`) with its own `main.tf`, `variables.tf`, and `outputs.tf` files. For example, a `resource-group` module might manage an Azure Resource Group and output its name and ID, while a `virtual-network` module creates a VNet using given parameters.

Your core `main.tf` (or environment-specific main) can instantiate these modules multiple times with different inputs. Modules promote **reusability and consistency**: all environments use the same module code for a resource, reducing drift. It’s a good idea to keep modules generic and input-driven (e.g., a module for an AKS cluster or App Service that takes environment-specific settings as inputs). This way, adding a new environment doesn’t require writing new resource definitions – you just reuse modules with new values.

*(If your project is small, you might not need many modules initially, but structuring the repo with a modules folder from the start allows the solution to grow in a maintainable way.)*

## Branching Strategy – Trunk-Based Development with PRs

We recommend a **lightweight trunk-based** workflow: use a single long-lived main branch (e.g. `main` or `master`) as the source of truth, and develop changes through short-lived feature branches that are merged via Pull Requests. In practice:

* **Main branch** holds the production-ready configuration. It includes all environments’ code (controlled by tfvars). This branch is protected – no direct commits; all changes go through PRs for review.
* **Feature branches** are created for any change (e.g., adding a module, changing a resource, or introducing a new environment). Developers branch off main, make changes, and open a Pull Request back into main. Each PR is a unit of work that can be reviewed and tested.
* **Pull Requests & Code Review:** Every PR triggers a Terraform **plan** (via CI pipeline) to show what infrastructure changes would occur. Team members must review the code and the plan output. **At least one approval** is required before merge (this ensures a human is checking the changes). This addresses the requirement of having a code review gate between planning and applying changes.
* **Fast-forward merges to main:** Once approved, the PR is merged into the main branch (ideally without long-lived divergence; trunk-based means keeping changes small and frequent). The merge, in turn, will trigger the apply (deployment) in the CI/CD workflow.

Trunk-based with PRs combines the best of both: you avoid complex long-lived branches (so all environments use the same codebase for consistency) while still enforcing quality via PR reviews. This strategy also naturally aligns with automation: you can automate Terraform plans on PRs and applies on merges, as described next.

## CI/CD Workflow with GitHub Actions (Plan & Apply via PR)

Using **GitHub Actions** for Terraform automation keeps the workflow streamlined (no extra tools needed). We propose using the open-source **TF-via-PR** action, which is designed for Terraform pull-request automation. The key ideas in the workflow:

* **Pull Request = Plan:** When a PR is opened or updated, the GitHub Actions workflow runs `terraform plan` (with `-var-file` pointing to the appropriate env file) and posts the plan results as a comment on the PR. The TF-via-PR action automatically formats the plan output in a friendly *diff* view for easy review. This gives everyone a clear view of what changes are proposed, right in the PR. For example, if the PR changes affect the dev environment, the action can run `terraform plan -var-file=env/dev.tfvars` and show the resource additions/changes/deletions. *(You might configure the workflow to run plans for all environments to see impact globally, or just target a specific env per PR – this is configurable.)*

* **Security & Consistency:** The TF-via-PR action **encrypts and saves the plan file** as a workflow artifact. This is important – it means the exact plan that was reviewed is preserved. When the PR is merged, we don’t rerun a fresh plan from scratch (which could drift if the code or external state changed); instead the saved, reviewed plan is reused for the apply step. This ensures what gets deployed is exactly what was approved in the PR. It prevents surprises caused by out-of-band changes or concurrent merges (a common IaC pitfall).

* **Merge = Apply:** After the PR is approved and merged into main, the workflow (triggered on push to main) will automatically run `terraform apply` using the previously stored plan file (via TF-via-PR). In practice, the action detects the merge event and switches to apply mode, applying the changes to the target environment. The apply can happen *before or after* merging depending on configuration, but a common setup is to apply *after* merge to main. Requiring the PR to be merged (not just closed) ensures only code that made it to the main branch (i.e., fully approved code) is deployed. Optionally, you might tag or label the PR to control whether an apply happens automatically or not; TF-via-PR supports flexible triggers.

* **GitHub Actions YAML:** The repository would include a workflow file (e.g., `.github/workflows/terraform-ci.yml`) that defines these steps. It would specify triggers on `pull_request` (for plan) and on `push` to main (for apply), and use `op5dev/tf-via-pr` (from GitHub Marketplace) in a job step. For example, one step might use: `uses: op5dev/tf-via-pr@vX` with inputs like `command: plan` or `apply`, `arg-var-file: env/<env>.tfvars`, etc., and appropriate permissions. The action takes care of commenting the plan on the PR and locking the plan file. In summary, **Terraform changes only go live after passing PR review and being merged**, at which point the CI ensures the exact reviewed plan is applied to Azure.

**Note:** The workflow will also need Azure credentials to perform Terraform operations. These should be provided securely (e.g., via Azure service principal secrets stored in GitHub) – see the next section on GitHub environments for how to handle this per environment.

## GitHub Environments for Secrets & Approvals

For each deployment environment (dev, staging, prod, etc.), define a corresponding **GitHub Environment** in your repo settings (e.g., an environment named "dev", one named "staging", etc.). These serve two purposes:

1. **Secure Storage of Secrets/Vars:** GitHub Environments let you scope secrets and variables to that environment. For example, you can add secrets like `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_SUBSCRIPTION_ID` for the dev environment, and different values for the prod environment. The CI workflow job that deploys to "prod" will **only have access to prod secrets** and not dev’s, and vice versa. This prevents cross-environment credential leaks and keeps sensitive values (like API keys, passwords) out of the repository. In our Terraform action, we can map these secrets to environment variables (the Azure provider picks up `ARM_CLIENT_ID`, etc.) or use them in `backend.tf` config.

2. **Deployment Protection Rules (Approvals):** GitHub Environments also allow setting **required reviewers** or manual approval steps before a job can proceed. You can use this feature to add an extra human checkpoint for sensitive environments. For instance, you may require a tech lead or SRE to **approve deployments to production**. With this configured, even after the PR is merged and the workflow is triggered, GitHub will pause **before applying to prod** and wait for an authorized person to approve the deployment run. This ensures higher environments get an extra gate (on top of code review) – satisfying the need for “additional approval steps on individual environments.” In GitHub Actions YAML, you’d specify `environment: prod` for the prod deployment job, and in settings mark that environment as requiring approval.

**Using GitHub Environments** ties everything together: the workflow’s plan/apply job for a given env will declare `environment: <env-name>`. It gains access to that env’s secrets (like the storage account key for remote state, any environment-specific config) and will be subject to its protection rules. This setup keeps credentials out of tfvars and code, and adds control for deployments.

## Adding New Environments

Since the number of environments isn’t fixed up front, the repository should make it easy to introduce a new one via a consistent process:

* **Create new tfvars:** e.g., if adding "qa" environment, add `env/qa.tfvars` with the appropriate variable values for that environment. Follow the naming conventions and structure used for other envs.
* **State backend config:** provision a separate Terraform state for the new env (e.g., create a new Azure storage blob or key with name `qa.terraform.tfstate`, or a new Terraform Cloud workspace, etc.). Update backend configurations to include the new environment’s details if needed (ensuring it doesn’t overlap with others).
* **GitHub environment & secrets:** in repo settings, create a new GitHub Environment named "qa". Add all required secrets (Azure credentials, etc.) for this environment. Also configure any protection rules (maybe QA requires a different approver, etc., or perhaps no manual approval if it’s lower-tier).
* **Pipeline adjustments:** If your GitHub Actions workflow is designed to run for all environments (e.g., using a matrix or triggering per env), ensure the new env is accounted for. For example, some setups have a matrix of env names to loop through; add "qa" there. If using separate workflows or jobs per env, duplicate/adapt one for the new env. With TF-via-PR, you might simply run plan/apply for all envs or specify which env to target in the PR – decide how new env fits into that logic.
* **Naming and conventions:** Keep names consistent (if you use short names like dev/prod in file names and environment names, stick to that). Update documentation (README) about the new environment.

By adhering to this template, each new environment is just a repeatable addition – no overhaul of structure. The code remains DRY (Don’t Repeat Yourself), as only variable files and perhaps some config for state/secrets are added, not copy-pasting entire Terraform configs.

## Summary of the Workflow

* **Modular codebase:** One set of Terraform config and modules serves all environments, with environment-specific tfvars for differences. This ensures consistency across Azure environments while avoiding code duplication.
* **Isolated state:** Each environment uses its own Terraform state (preventing cross-environment interference), for example by keying state files by environment in an Azure storage backend.
* **Trunk-based branching:** Use a single main branch with short feature branches and PRs for changes, rather than separate long-lived branches per environment. This simplifies collaboration and ensures all changes are vetted via PR.
* **GitHub Actions CI/CD:** Implement an automated pipeline where PRs trigger `terraform plan` and post the diff, and merges trigger `terraform apply`. The TF-via-PR action helps implement secure plan-and-apply via PR, reusing the plan file so the apply is exactly what was approved. This provides transparency (everyone sees the plan in the PR) and safety (only approved changes get deployed).
* **Approvals and security:** Leverage GitHub environment-scoped secrets to supply sensitive data (like Azure credentials) to the workflow securely. Use environment protection rules (like required reviewer approvals on production) to introduce manual checkpoints for critical deployments. Combined with the mandatory PR code review before merge, this gives a two-tier approval process for production changes (code review + deployment approval).

By following this boilerplate structure, your Terraform repo will be well-organized, extensible to new Azure environments, and integrated with a robust CI/CD process that encourages best practices in infrastructure-as-code (code reviews, incremental plans, and controlled deployments). This makes your Azure deployments more maintainable and secure over time.

**Sources:** Best practices from community tutorials and official docs were used to shape this answer. Key references include recommended Terraform project structures, usage of tfvars for multi-env setups, and guidance on PR-driven Terraform workflows with GitHub Actions. Each citation points to the relevant source material for further reading on that topic. Happy Terraforming!
