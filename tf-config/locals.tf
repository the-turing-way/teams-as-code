locals {
  files     = fileset("${path.root}/..", "teams/*.yaml")
  teams_map = { for filename in local.files : replace(replace(filename, ".yaml", ""), "teams/", "") => yamldecode(file("${path.root}/../${filename}")) }

  # Flatten team-repository permissions for github_team_repository resource
  team_repo_permissions = flatten([
    for team in local.teams_map : [
      for permission in lookup(team, "permissions", []) : {
        team_name = team.name
        repo      = permission.repo
        role      = permission.role
        key       = "${team.name}-${permission.repo}"
      }
    ]
  ])
  team_repo_map = { for item in local.team_repo_permissions : item.key => item }

  # Flatten team-member relationships for github_team_membership resource
  team_memberships = flatten([
    for team in local.teams_map : [
      for member in lookup(team, "members", []) : {
        team_name = team.name
        user_map  = member
        key       = "${team.name}-${user_map.user}"
      }
    ]
  ])
  team_membership_map = { for item in local.team_memberships : item.key => item }
}
