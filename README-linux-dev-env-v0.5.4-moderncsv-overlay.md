# linux-dev-env v0.5.4 ModernCSV Overlay

## Purpose

This overlay updates `linux-dev-env` with the shared application standard created while installing ModernCSV under `/opt/apps`.

It adds documentation for:

- `/opt/apps` as the standard location for manually installed shared applications
- `/opt/projects` as the standard location for shared project repositories
- `/usr/local/bin` as the standard location for shared launchers and symlinks
- ModernCSV installation under `/opt/apps/moderncsv`
- Correct GUI application validation for another user such as `bas`

## Files Added

```text
docs/apps/moderncsv.md
docs/standards/application-placement.md
```

## Pre-Overlay Check

From the repo:

```bash
cd ~/pjs/repos/linux-dev-env

whoami
git status
git branch
git remote -v
```

Expected branch before applying:

```text
main
```

Expected current status may include:

```text
Untracked files:
  docs/apps/
```

That is okay if `docs/apps/moderncsv.md` was created manually. This overlay will provide the standardized version.

## Create Safety Backup

```bash
mkdir -p ~/pjs/tmp/linux-dev-env-backups

cp -R ~/pjs/repos/linux-dev-env \
  ~/pjs/tmp/linux-dev-env-backups/linux-dev-env-before-v0.5.4-moderncsv-$(date +%Y%m%d-%H%M%S)
```

## Apply Overlay

Assuming the overlay zip is in `~/Downloads`:

```bash
cd ~/Downloads

unzip linux-dev-env-v0.5.4-moderncsv-overlay.zip

cp -Rv \
  ~/Downloads/linux-dev-env-v0.5.4-moderncsv-overlay/* \
  ~/pjs/repos/linux-dev-env/
```

## Review Result

```bash
cd ~/pjs/repos/linux-dev-env

find docs -maxdepth 3 -type f | sort

git status

git diff -- docs/apps/moderncsv.md docs/standards/application-placement.md
```

## Optional Markdown Sanity Check

```bash
sed -n '1,220p' docs/apps/moderncsv.md
sed -n '1,220p' docs/standards/application-placement.md
```

## Commit Workflow

```bash
cd ~/pjs/repos/linux-dev-env

git status

git add docs/apps/moderncsv.md docs/standards/application-placement.md

git diff --cached --stat

git commit -m "docs: add shared app standard and ModernCSV guide"
```

## Push Workflow

If committing directly to `main` is acceptable for this repo:

```bash
git push
```

If you prefer a feature branch instead:

```bash
git checkout -b feature/v0.5.4-moderncsv-shared-apps

git push -u origin feature/v0.5.4-moderncsv-shared-apps
```

Then merge later through your preferred GitHub flow.

## Post-Commit Verification

```bash
git status

git log --oneline -5
```

## ModernCSV Install Verification Summary

Installed application:

```text
/opt/apps/moderncsv
```

Shared launcher:

```text
/usr/local/bin/moderncsv
```

Desktop launcher:

```text
/usr/share/applications/moderncsv.desktop
```

Correct `bas` GUI test:

```text
Log in as bas from the Pop!_OS graphical login screen and launch Modern CSV from the Applications menu.
```

Do not use this as the primary GUI test:

```bash
sudo -iu bas
moderncsv
```

That can fail because `bas` does not own or have authorization to use `pl`'s active graphical session.

## Recommended Next Step

After this is committed and pushed, continue with MotorWeb using `linux-dev-env` as the documented source of truth.

MotorWeb should align with:

```text
/opt/apps      shared installed applications
/opt/projects  shared project repositories
/usr/local/bin shared launchers
```
