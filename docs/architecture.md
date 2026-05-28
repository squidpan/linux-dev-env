# Architecture

## Purpose

`linux-dev-env` is a lightweight configuration-management repo for Linux developer users.

It is not intended to be a full enterprise user-management system. It is a practical learning and workstation-management framework.

## Core Model

```text
bas = reference/template account
linux-dev-env = source of truth
dev/tester accounts = managed targets
```

The repo owns reusable configuration.

Individual users own private state.

## What The Repo Manages

- shell modules
- user profile type
- baseline directories
- shared project permissions
- user creation scripts
- user update/reconciliation scripts
- archive/delete lifecycle scripts
- documentation

## What The Repo Must Not Manage

- SSH private keys
- browser profiles
- cookies
- IDE caches
- personal Obsidian app state
- `.env` secrets
- shell history
- one-off temporary files

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

## Directory Strategy

### Shared application projects

```text
/opt/projects
```

Use for application-style repos or shared development work.

Example:

```text
/opt/projects/motorweb
```

### User workspace

```text
~/pjs/
├── repos/
├── vaults/
├── scripts/
└── tmp/
```

Use for user-owned repos, vaults, scripts, and experiments.

## MotorWeb Pattern

```text
Location: /opt/projects/motorweb
Shared group: projects
Git safe directory:
    git config --global --add safe.directory /opt/projects/motorweb
```

## Golden Rule

The repo is the source of truth.

For shared changes:

1. Update repo-managed files.
2. Commit.
3. Dry-run update.
4. Apply to one user.
5. Validate.
6. Roll out to all managed users.
