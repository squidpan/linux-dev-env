# Overlay And Git Workflow

Use this workflow to overlay this package into the existing `linux-dev-env` repo and push to GitHub.

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

## C. Verify Repo

```bash
git status
git branch
git remote -v
```

Expected branch:

```text
main
```

Expected remote:

```text
git@github.com:squidpan/linux-dev-env.git
```

## D. Update Main

```bash
git checkout main
git pull
```

## E. Create Feature Branch

```bash
git checkout -b feature/docs-reorganization-full
```

## F. Backup Current Repo

```bash
mkdir -p ~/pjs/tmp/linux-dev-env-backups

cp -R ~/pjs/repos/linux-dev-env \
  ~/pjs/tmp/linux-dev-env-backups/linux-dev-env-before-docs-full-$(date +%Y%m%d-%H%M%S)
```

## G. Extract Overlay

Assuming downloaded ZIP is in `~/Downloads`:

```bash
cd ~/Downloads
unzip linux-dev-env-full-docs-overlay.zip
```

## H. Overlay Files

```bash
cp -Rv ~/Downloads/linux-dev-env-full-docs-overlay/* \
  ~/pjs/repos/linux-dev-env/
```

## I. Return To Repo

```bash
cd ~/pjs/repos/linux-dev-env
```

## J. Optional Rename Existing Bootstrap README

If the old bootstrap README still exists at repo root:

```bash
if [ -f README_bas_linux_dev_environment_full_setup_readme.md ]; then
  mv README_bas_linux_dev_environment_full_setup_readme.md docs/bas-bootstrap-original.md
fi
```

## K. Make Scripts Executable

```bash
chmod +x setup/*.sh 2>/dev/null || true
```

## L. Validate Markdown Layout

```bash
tree -a -L 3
```

## M. Validate Shell Script Syntax

```bash
bash -n setup/*.sh
```

No output means syntax OK.

## N. Review Git Changes

```bash
git status
git diff --stat
```

## O. Stage Changes

```bash
git add .
```

## P. Review Staged Changes

```bash
git diff --cached --stat
```

## Q. Commit

```bash
git commit -m "docs: reorganize linux dev env architecture and user guides"
```

## R. Push Feature Branch

```bash
git push -u origin feature/docs-reorganization-full
```

## S. Merge To Main

```bash
git checkout main
git pull
git merge feature/docs-reorganization-full
```

## T. Push Main

```bash
git push
```

## U. Verify Remote

```bash
git status
git log --oneline -5
```

Optionally check in browser:

```text
https://github.com/squidpan/linux-dev-env
```

## V. Optional Cleanup

```bash
git branch -d feature/docs-reorganization-full
git push origin --delete feature/docs-reorganization-full
```

## W. After This

Switch back to MotorWeb work.

Recommended next command:

```bash
cd /opt/projects/motorweb
git status
```
