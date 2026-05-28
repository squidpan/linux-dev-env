# linux-dev-env

Reusable Linux developer-environment framework for building and managing clean Linux users from a `bas` template model.

## Purpose

This repo supports:

- `bas` — base/template developer account
- `dev` users — full developer accounts
- `tester` / `ted` users — lighter tester accounts
- shared project access under `/opt/projects`
- consistent shell/profile installation
- user update/reconciliation from repo-managed baseline
- user archive/delete lifecycle management

This repo does **not** clone `/home/bas` directly.

Instead, `bas` acts as the reference model, while reusable shell files, profile definitions, and management scripts live in Git.

## Why Not Clone `/home/bas` Directly?

Directly copying `/home/bas` can accidentally copy:

- SSH private keys
- browser cookies
- Chrome profiles
- Obsidian state
- VS Code state
- PyCharm caches
- `.env` secrets
- shell history
- temporary files
- stale project data

The safer pattern is:

```text
bas = reference/template
linux-dev-env repo = source of truth
dev/tester users = managed targets
```

## Repository Structure

```text
linux-dev-env/
├── README.md
├── setup/
│   ├── create-dev-user.sh
│   ├── create-test-user.sh
│   ├── install-user-shell.sh
│   ├── configure-shared-projects.sh
│   ├── update-managed-user.sh
│   ├── update-all-managed-users.sh
│   ├── check-managed-user.sh
│   ├── archive-user.sh
│   ├── delete-user.sh
│   └── list-managed-users.sh
├── shell/
│   ├── env.sh
│   ├── paths.sh
│   ├── aliases.sh
│   ├── functions.sh
│   └── prompt.sh
├── profiles/
│   ├── managed-users.csv
│   ├── base/
│   │   └── profile.env
│   ├── dev/
│   │   └── profile.env
│   └── tester/
│       └── profile.env
└── docs/
    ├── overlay-and-git-workflow.md
    └── user-management.md
```

## User Types

### `bas`

The base/reference environment.

Used to validate:

- modular shell structure
- Python 3.13 venv workflow
- Docker workflow
- GitHub SSH setup
- Obsidian workflow
- MotorWeb shared project access

### `dev`

Developer accounts such as:

```text
dev1
dev2
appdev1
```

Expected capabilities:

- Git/GitHub SSH
- Python 3.13 venvs
- Docker access
- VS Code
- Obsidian lab vault
- shared `/opt/projects` access

### `tester` / `ted`

Tester accounts such as:

```text
ted1
tester-a
jimi-tester
```

Expected capabilities:

- basic shell environment
- project navigation
- shared project access
- controlled tooling

## Shared Project Area

Shared application-style repos live under:

```text
/opt/projects
```

Example:

```text
/opt/projects/motorweb
```

If Git reports dubious ownership:

```bash
git config --global --add safe.directory /opt/projects/motorweb
```

## Common Commands

Configure shared projects:

```bash
sudo bash setup/configure-shared-projects.sh
```

Create dev user:

```bash
sudo bash setup/create-dev-user.sh dev1
sudo bash setup/install-user-shell.sh dev1 dev
```

Create tester user:

```bash
sudo bash setup/create-test-user.sh ted1
sudo bash setup/install-user-shell.sh ted1 tester
```

Update one user from current repo baseline:

```bash
sudo bash setup/update-managed-user.sh dev1 dev
```

Update all managed users:

```bash
sudo bash setup/update-all-managed-users.sh
```

Check one managed user:

```bash
bash setup/check-managed-user.sh dev1 dev
```

Archive user:

```bash
sudo bash setup/archive-user.sh dev1
```

Delete user safely:

```bash
sudo bash setup/delete-user.sh dev1
```

List managed users:

```bash
bash setup/list-managed-users.sh
```

## Python 3.13 Workflow

Use explicit Python 3.13:

```bash
python3.13 -m venv .venv
source .venv/bin/activate
python --version
```

Do not rely on plain `python3` if it points to Python 3.10.

## GUI App Rule

For Chrome, Obsidian, VS Code, and PyCharm:

Use a real graphical login as the target user.

Do not expect GUI apps to work correctly from:

```bash
su - username
```

That is not a full desktop session.
