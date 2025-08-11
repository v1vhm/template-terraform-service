# Repository Provisioning

This directory contains configuration consumed by automated tooling when a new repository is created from this template. The file [`repository-config.yml`](repository-config.yml) is the single source of truth for initial GitHub settings.

## Schema

`repository-config.yml` follows a versioned schema:

```yaml
version: 1

repository:
  topics: ["terraform","service","platform"] # optional
  visibility: public|private|internal              # optional
  description: "Terraform-based service scaffold" # optional

rulesets:            # optional list -> github_repository_ruleset
  - name: string
    target: "branch"
    enforcement: "active" | "evaluate" | "disabled"
    conditions:
      ref_name:
        include: [string]
        exclude: [string]
    rules:
      - type: "deletion" | "non_fast_forward" | "pull_request" | "code_scanning" | "required_status_checks"
        parameters:        # shape depends on type
          required_approving_review_count: int
          dismiss_stale_reviews_on_push: bool
          require_code_owner_review: bool
          require_last_push_approval: bool
          required_review_thread_resolution: bool
          code_scanning_tools:
            - tool: "CodeQL"
          required_status_checks:
            - context: string
          strict_required_status_checks_policy: bool
          do_not_enforce_on_create: bool
          allowed_merge_methods: ["merge","squash","rebase"]

labels:              # -> github_issue_label
  - name: string
    color: string        # hex (no #)
    description: string

teams:               # -> github_team_repository
  - team: string         # slug
    permission: "pull" | "push" | "maintain" | "triage" | "admin"

variables:           # -> github_actions_repository_variable
  - name: string
    value: string

secrets:             # -> github_actions_secret (value supplied by workflow env)
  - name: string
    source: "workflow_secret" | "env" | "none"
    ref: string           # e.g. "MY_ORG_SECRET_NAME" when source != none
```

## Usage

1. Update [`repository-config.yml`](repository-config.yml) with the desired settings.
2. Run your organization's provisioning tooling to apply the configuration when creating the repository.
3. Updates only affect repositories created after the change; existing repositories are not modified.

## Validation

To catch configuration errors early, validate `repository-config.yml` against its schema:

```bash
python validate_config.py
```

This helper script was added as part of the task to ensure repository provisioning data remains consistent.
