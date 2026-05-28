# User Management Framework

## Goal

Use `bas` as the reference environment while managing real users through this repo.

The repo should enforce:

- consistent shell files
- consistent directory structure
- consistent profile type
- consistent shared project permissions
- safe user lifecycle management

## Baseline Managed Directories

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

Edit:

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

## Archive User

```bash
sudo bash setup/archive-user.sh dev1
```

Archives go to:

```text
/opt/user-archives
```

## Delete User

Safer delete with archive:

```bash
sudo bash setup/delete-user.sh dev1
```

Delete without archive:

```bash
sudo bash setup/delete-user.sh dev1 --no-archive
```

Protected users:

- root
- pl
- bas

The delete script refuses to delete these.

## Recommended Operational Flow

1. Update repo-managed shell/profile files.
2. Commit changes.
3. Dry-run update.
4. Apply to one test user.
5. Check user.
6. Apply to all managed users.
7. Commit operational notes.

Example:

```bash
sudo bash setup/update-managed-user.sh dev1 dev --dry-run
sudo bash setup/update-managed-user.sh dev1 dev
bash setup/check-managed-user.sh dev1 dev

sudo bash setup/update-all-managed-users.sh --dry-run
sudo bash setup/update-all-managed-users.sh
```
