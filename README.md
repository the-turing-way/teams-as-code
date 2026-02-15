# teams-as-code

Declaratively managing GitHub Team membership and permissions of *The Turing Way*
community.

## Adding a new team

Adding a new file to the [`teams`](./teams) folder named `<new-team>.yaml` will
create a new team once the Pull Request adding the file has been merged. You can
also define the members of the team and the permissions it has on given repos
within the file. The format looks like this:

```yaml
name: new-team
description: "A short description of the team's purpose"  # Optional
privacy: closed  # Optional
parent-team: new-team-parent  # Optional
members:
  - user: username1
    maintainer: true  # This team member will be able to manage the team
  - user: username2
permissions:
  - repo: repo1
    role: push
  - repo: repo2
    role: pull
  - repo: repo3
    role: maintain
  - repo: repo4
    role: triage
```

> [!WARNING]
> Note the following requirements:
>
> - `name` MUST include only lowercase letters, numbers, or hyphens. For example,
>   `my-new-team` will succeed, but `My New Téam` will not.
> - GitHub Teams can be [nested](https://docs.github.com/en/organizations/organizing-members-into-teams/about-teams#nested-teams).
>   If you wish your team to be the child of another, provide the name of that
>   team here. It MUST include only lowercase letters, numbers, or hyphens.
> - If defining `privacy`, it MUST take a value from `closed` or `secret`.
> - `role` MUST take a value from: `pull` (equivalent to `read`), `triage`,
>   `push` (equivalent to `write`), `maintain`, or `admin`.

Once you have made your edits, open a Pull Request and the workflows will trigger
to validate them and run a plan of the changes.
*The changes will only be applied after the Pull Request is merged.*

### Self-managing your team

There are two pieces to include that will allow your team to self-manage through
this repository.

Firstly, in your team's file under the [`teams`](./teams) folder, under
`permissions`, ensure you have included this repository with the `push` role.

```yaml
permissions:
  - repo: teams-as-code
    role: push
```

Then in the [`CODEOWNERS`](./CODEOWNERS) file, add your team to the end of the
list, in the format:

```text
teams/<your-team>.yaml @the-turing-way/<your-team>
```

> [!WARNING]
> Note that your team's name will have been changed to lower case, whitespace
> swapped for hyphens, and any special characters replaced.
> For example: 'My Téam' will become `my-team`.

Open a Pull Request with these changes. Once merged, this will request your team
to review future Pull Requests against your team's file and allow that team's
members to merge themselves, providing that tests pass.

## Deleting a team

Deleting a team is as simple as removing the file from the [`teams`](./teams)
folder and opening/merging a Pull Request.

## How does this repo work? (More detail.)

This repo uses [opentofu](https://opentofu.org/) to declaratively manage the
state of the GitHub Teams, their membership, and repo permissions in
[_The Turing Way_ GitHub organisation](https://github.com/the-turing-way).
This helps us know exactly who has what permissions where, and easily manage that.

The state of the teams, membership, and permissions we wish to declare are
stored in the [`teams.yaml`](./teams.yaml) file, so that making changes to this
file via Pull Requests are applied by opentofu through the
[`plan-and-apply.yaml`](.github/workflows/plan-and-apply.yaml) workflow.

The state is backed up into an object storage bucket currently hosted in GCP;
however, the state can be flexibly moved between buckets and cloud providers.

There are also some workflows that validate any changes made to the yaml file
and opentofu config to ensure its correctness.
