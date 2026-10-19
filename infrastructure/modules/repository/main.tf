resource "github_repository" "this" {
  name         = var.name
  description  = var.description
  homepage_url = var.homepage_url
  topics       = var.topics
  visibility   = "public"

  has_issues   = true
  has_projects = false
  has_wiki     = false

  allow_merge_commit     = true
  allow_squash_merge     = true
  allow_rebase_merge     = true
  allow_auto_merge       = true
  delete_branch_on_merge = true
  archive_on_destroy     = true
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = "main"
}

resource "github_branch_protection_v3" "this" {
  repository                      = github_repository.this.name
  branch                          = github_branch_default.this.branch
  enforce_admins                  = true
  require_conversation_resolution = true

  dynamic "required_status_checks" {
    for_each = length(var.required_checks) > 0 ? [var.required_checks] : []
    content {
      strict = true
      # 15368 is GitHub Actions' app ID on github.com. No spoofable any-app checks.
      checks = [for context in required_status_checks.value : "${context}:15368"]
    }
  }

  required_pull_request_reviews {
    required_approving_review_count = 0
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = false
    require_last_push_approval      = false
  }
}
