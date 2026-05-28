# linux-dev-env

Reusable Linux developer-environment framework for building, documenting, and managing clean Linux users from a `bas` template model.

## Purpose

This repo supports:

- `bas` — base/reference developer account
- `dev` users — full developer accounts
- `tester` / `ted` users — lighter tester accounts
- shared project access under `/opt/projects`
- consistent shell/profile installation
- user update/reconciliation from repo-managed baseline
- user archive/delete lifecycle management
- repeatable Linux developer workstation setup

This repo does **not** clone `/home/bas` directly.

Instead:

```text
bas = reference/template account
linux-dev-env repo = source of truth
dev/tester users = managed targets
```

## Golden Rule

The `linux-dev-env` repository is the source of truth.

Do **not** manually modify managed user shell configuration if the change should apply to more than one user.

Instead:

1. Modify repo files.
2. Commit changes.
3. Dry-run against one user.
4. Apply to one user.
5. Validate.
6. Roll out to all managed users.
7. Commit any documentation updates.

## Architecture Layers

```text
Layer 1 - Operating System
    Pop!_OS

Layer 2 - Shared Infrastructure
    /opt/projects
    docker
    groups

Layer 3 - User Profiles
    base
    dev
    tester

Layer 4 - Shell Framework
    shell/*.sh

Layer 5 - Development Tooling
    git
    Python 3.13
    VS Code
    Obsidian
    PyCharm / JetBrains Toolbox

Layer 6 - Applications / Workflows
    motorweb
    mw_notes_job
    obsidian-skills-ng
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
    ├── architecture.md
    ├── bas-bootstrap.md
    ├── user-management.md
    └── overlay-and-git-workflow.md
```

## Main Guides

Read these in order:

1. [`docs/architecture.md`](docs/architecture.md)
2. [`docs/bas-bootstrap.md`](docs/bas-bootstrap.md)
3. [`docs/user-management.md`](docs/user-management.md)
4. [`docs/overlay-and-git-workflow.md`](docs/overlay-and-git-workflow.md)

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

Shared group:

```text
projects
```

If Git reports dubious ownership:

```bash
git config --global --add safe.directory /opt/projects/motorweb
```

## Common Commands

Configure shared project area:

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

Update one user:

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

## Managed Users Manifest

File:

```text
profiles/managed-users.csv
```

Example:

```csv
bas,base
dev1,dev
dev2,dev
ted1,tester
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

## Current Project Context

This repo supports work on:

- `/opt/projects/motorweb`
- `mw_notes_job`
- `obsidian-skills-ng`
- Python learning
- Spring Boot learning
- Docker-based development
- Obsidian/ChatGPT workflow experiments
