output "repository" {
  description = "Managed GitHub repository URL and About settings."
  value = {
    name         = github_repository.this.name
    html_url     = github_repository.this.html_url
    description  = github_repository.this.description
    homepage_url = github_repository.this.homepage_url
    topics       = github_repository.this.topics
  }
}

output "required_status_checks" {
  description = "Required default-branch checks and their strictness."
  value = [for status_checks in github_branch_protection_v3.this.required_status_checks : {
    checks = status_checks.checks
    strict = status_checks.strict
  }]
}
