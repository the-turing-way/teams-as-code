resource "github_team" "teams" {
  for_each = local.teams_map

  name        = each.value.name
  description = lookup(each.value, "description", null)
  privacy     = lookup(each.value, "privacy", "closed")
}

resource "github_repository_collaborators" "team_repos" {
  for_each   = local.team_repo_map
  repository = each.value.repo

  team {
    permission = each.value.role
    team_id    = github_team.teams[each.value.team_name].slug
  }
}

resource "github_team_membership" "team_members" {
  for_each = local.team_membership_map

  team_id  = github_team.teams[each.value.team_name].id
  username = each.value.user_map.user
  role     = contains(keys(each.value.username), "maintainer") ? "maintainer" : "member"
}
