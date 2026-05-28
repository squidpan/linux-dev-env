# User Management Guide

## Purpose

Manage dev/tester users consistently from the repo-defined baseline.

## User Types

```text
base    -> bas
dev     -> dev1, dev2, appdev1
tester  -> ted1, tester-a, jimi-tester
```

## Why Not Clone `/home/bas`?

Do not copy `/home/bas` directly.

It may contain:

- SSH private keys
- browser cookies
- Obsidian state
- VS Code state
- PyCharm cache
- `.env` files
- shell history
- temporary files

## Managed Directories

Each managed user gets:

```text
~/pjs/repos
~/pjs/vaults
~/pjs/scripts
~/pjs/tmp
~/bin
~/.config/shell
~/dotfiles/originals
```

## Manifest

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

## Configure Shared Projects

```bash
sudo bash setup/configure-shared-projects.sh
```

## Create Dev User

```bash
sudo bash setup/create-dev-user.sh dev1
sudo bash setup/install-user-shell.sh dev1 dev
```

## Create Tester/Ted User

```bash
sudo bash setup/create-test-user.sh ted1
sudo bash setup/install-user-shell.sh ted1 tester
```

## Update One User

Dry run:

```bash
sudo bash setup/update-managed-user.sh dev1 dev --dry-run
```

Apply:

```bash
sudo bash setup/update-managed-user.sh dev1 dev
```

## Update All Users

Dry run:

```bash
sudo bash setup/update-all-managed-users.sh --dry-run
```

Apply:

```bash
sudo bash setup/update-all-managed-users.sh
```

## Check User

```bash
bash setup/check-managed-user.sh dev1 dev
```

## List Managed Users

```bash
bash setup/list-managed-users.sh
```

## Archive User

```bash
sudo bash setup/archive-user.sh dev1
```

Archives go to:

```text
/opt/user-archives
```

## Delete User

With archive:

```bash
sudo bash setup/delete-user.sh dev1
```

Without archive:

```bash
sudo bash setup/delete-user.sh dev1 --no-archive
```

Protected users:

```text
root
pl
bas
```

The delete script refuses to delete these.

## Operational Flow

1. Update repo-managed files.
2. Commit.
3. Dry-run one user.
4. Apply to one user.
5. Check.
6. Update all users.
7. Commit notes if needed.
