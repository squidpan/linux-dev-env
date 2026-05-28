# Overlay And Git Workflow

This document describes how to overlay this package into the existing `linux-dev-env` repo, validate it, commit it, and push it.

## A. Start As `bas`

```bash
whoami
```

Expected:

```text
bas
```

## B. Go To Repo

```bash
cd ~/pjs/repos/linux-dev-env
```

## C. Verify Current Repo

```bash
git status
git branch
git remote -v
```

Expected:

```text
On branch main
```

and:

```text
origin git@github.com:squidpan/linux-dev-env.git
```

## D. Create Feature Branch

```bash
git checkout main
git pull
git checkout -b feature/user-management-framework
```

## E. Backup Current Repo Snapshot

```bash
mkdir -p ~/pjs/tmp/linux-dev-env-backups

cp -R ~/pjs/repos/linux-dev-env \
  ~/pjs/tmp/linux-dev-env-backups/linux-dev-env-before-user-management-$(date +%Y%m%d-%H%M%S)
```

## F. Extract Overlay ZIP

Assuming the ZIP was downloaded to `~/Downloads`:

```bash
cd ~/Downloads
unzip linux-dev-env-user-management-overlay.zip
```

This should create:

```text
linux-dev-env-user-management-overlay/
```

## G. Overlay Files Into Repo

```bash
cp -Rv ~/Downloads/linux-dev-env-user-management-overlay/* \
  ~/pjs/repos/linux-dev-env/
```

## H. Return To Repo

```bash
cd ~/pjs/repos/linux-dev-env
```

## I. Ensure Scripts Are Executable

```bash
chmod +x setup/*.sh
```

## J. Inspect Tree

```bash
tree -a -L 3
```

Expected high-level structure:

```text
.
├── README.md
├── docs
├── profiles
├── setup
└── shell
```

## K. Check Script Syntax

```bash
bash -n setup/*.sh
```

No output means syntax is OK.

## L. Check Usage Messages

```bash
bash setup/create-dev-user.sh
bash setup/create-test-user.sh
bash setup/install-user-shell.sh
bash setup/update-managed-user.sh
bash setup/delete-user.sh
```

Each should show a usage message.

## M. Review Git Changes

```bash
git status
git diff --stat
```

## N. Stage Changes

```bash
git add .
```

## O. Review Staged Changes

```bash
git diff --cached --stat
```

Optional full review:

```bash
git diff --cached
```

## P. Commit

```bash
git commit -m "feat: add managed dev and tester user framework"
```

## Q. Push Feature Branch

```bash
git push -u origin feature/user-management-framework
```

## R. Merge To Main Locally

If everything looks good:

```bash
git checkout main
git pull
git merge feature/user-management-framework
```

## S. Push Main

```bash
git push
```

## T. Optional Cleanup Feature Branch

```bash
git branch -d feature/user-management-framework
```

Optional remote cleanup:

```bash
git push origin --delete feature/user-management-framework
```

## U. Configure Shared Projects

```bash
sudo bash setup/configure-shared-projects.sh
```

## V. Dry Run User Update

Example:

```bash
sudo bash setup/update-managed-user.sh bas base --dry-run
```

For a future dev user:

```bash
sudo bash setup/update-managed-user.sh dev1 dev --dry-run
```

## W. Create A Dev User Later

```bash
sudo bash setup/create-dev-user.sh dev1
sudo bash setup/install-user-shell.sh dev1 dev
```

## X. Create A Tester/Ted User Later

```bash
sudo bash setup/create-test-user.sh ted1
sudo bash setup/install-user-shell.sh ted1 tester
```

## Y. Add Users To Manifest

Edit:

```text
profiles/managed-users.csv
```

Example:

```csv
bas,base
dev1,dev
ted1,tester
```

## Z. Update All Managed Users

Dry run:

```bash
sudo bash setup/update-all-managed-users.sh --dry-run
```

Apply:

```bash
sudo bash setup/update-all-managed-users.sh
```
