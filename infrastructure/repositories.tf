locals {
  base_repos = {
    ".github" = {
      description     = "Tuxcrate organization profile and shared GitHub configuration."
      required_checks = toset(["validate"])
    }
    "docs" = {
      description     = "The Tuxcrate website. Open source apps, ready to run."
      required_checks = toset(["build", "test"])
    }
    "github-actions" = {
      description     = "Shared GitHub Actions workflows for Tuxcrate container images"
      homepage_url    = "https://tuxcrate.com/maintainers/container-releases/"
      required_checks = toset(["test"])
    }
  }
  container_repos = toset([
    "gallery-dl",
    "prowlarr",
    "radarr",
    "sonarr",
    "zrepl",
  ])
  container_release_metadata = {
    for repo in local.container_repos :
    repo => yamldecode(file("${path.module}/../../${repo}/meta.yaml"))
  }
  container_metadata = {
    for repo in local.container_repos :
    repo => yamldecode(regex(
      "(?s)^---\\r?\\n(.*?)\\r?\\n---(?:\\r?\\n|$)",
      file("${path.module}/../../docs/docs/containers/${repo}.md")
    )[0]).container
  }
  repositories = merge(local.base_repos, {
    for repo in local.container_repos :
    repo => {
      homepage_url = "https://tuxcrate.com/containers/${repo}/"
      description  = local.container_metadata[repo].description
      topics       = concat(local.container_metadata[repo].topics, ["tuxcrate"])
      # Match the shared workflow's check names for every declared track.
      required_checks = setunion(toset(["container / plan"]), toset([
        for track in local.container_release_metadata[repo].tracks :
        "container / pull-request (${track.name})"
      ]))
    }
  })
}

module "repository" {
  source   = "./modules/repository"
  for_each = local.repositories

  name            = each.key
  description     = each.value.description
  homepage_url    = try(each.value.homepage_url, "https://tuxcrate.com")
  topics          = try(each.value.topics, [])
  required_checks = each.value.required_checks
}
