output "repositories" {
  description = "Repositories managed by this stack."
  value = {
    for name, repo in module.repository : name => repo.repository.html_url
  }
}
