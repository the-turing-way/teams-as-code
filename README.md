# teams-as-code

Declaratively managing GitHub Team membership and permissions of *The Turing Way*
community.

## Adding a new team

Adding a new item to the list in the [`teams.yaml`](./teams.yaml) file will create
a new team. You can also define the members of the team and the permissions it
has on given repos. The format looks like this:

```yaml
- name: new-team
  description: "A short description of the team's purpose"  # not required
  members:
    - username1
    - username2
  permissions:
    - repo: repo1
      role: write
    - repo: repo2
      role: read
  privacy: closed  # Optional. Can be "secret" or "closed". Defaults to "closed".
```

> [!WARNING]
> Note that `role` MUST take a value from: `read`, `triage`, `write`, `maintain`,
> or `admin`.

Once you have made your edits, open a Pull Request and the worflows will trigger
to validate them and run a plan of the changes.
*The changes will only be applied after the Pull Request is merged.*

### Self-Managing your Team

There are two pieces to include that will allow your team to self-manage through
this repository.

Firstly, in the [`teams.yaml`](./teams.yaml) file in your team's permissions
section, ensure you have included this repository with the `write` role.

```yaml
- repo: teams-as-code
  role: write
```

Then in the [`CODEOWNERS`](./CODEOWNERS) file, add your team to the line that
begins with `teams.yaml` in the format `@the-turing-way/<team-name>`.

These will request your team to review Pull Requests against the `teams.yaml` file
and allow that team's members to merge themselves, providing that tests pass.

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
