# .github

Tuxcrate organization profile and shared GitHub configuration.

The [`infrastructure/`](infrastructure/) directory contains OpenTofu configuration for GitHub repository metadata and branch protection across the organization.

Run OpenTofu from that directory. It reads the sibling `docs/` repository
checkout in the workspace, so that must be present and current.
State and plans use OpenTofu encryption; provide `state_passphrase` securely and
keep it out of Git. GitHub authentication comes from `GITHUB_TOKEN`.

Validate locally without applying changes:

```sh
cd infrastructure
tofu init -backend=false -lockfile=readonly
tofu fmt -check -recursive
tofu validate
```

Before adopting any existing repository, import its repository, default branch,
and existing branch protection into the corresponding module resources. Review
the plan before applying; existing repositories must not be created or replaced.
For example, if `renovate-config` is not already in state:

```sh
tofu import 'module.repository["renovate-config"].github_repository.this' renovate-config
tofu import 'module.repository["renovate-config"].github_branch_default.this' renovate-config
tofu import 'module.repository["renovate-config"].github_branch_protection_v3.this' renovate-config:main
```

These imports update local state, not GitHub settings. Run them only after
confirming the resource is not already managed in state. The Actions workflow
checks formatting only; it does not plan or apply organization changes.

Container repositories require the shared workflow's fixed
`container / pull-request-check` aggregate check. It covers planning and every
active track build without requiring checks for dormant prerelease tracks.
Publish the shared workflow and rerun all jobs in open PR workflows before
applying this branch-protection change; then replace the old per-track check
requirements. Rerunning only failed jobs can reuse the old shared-workflow commit.
