# Application Placement Standard

## Purpose

Define where shared applications, project repositories, command launchers, and user-specific configuration should live on this Linux development workstation.

This standard keeps the environment understandable for multiple users such as `pl`, `bas`, and future users.

## Standard Layout

```text
/opt/apps      Shared manually installed applications
/opt/projects  Shared repositories and project workspaces
/opt/tools     Shared scripts, helper tools, or internal utilities
/usr/local/bin Shared command launchers, wrappers, and symlinks
~/.config      Per-user application configuration
~/.local/bin   Per-user command launchers and scripts
```

## `/opt/apps`

Use `/opt/apps` for manually installed shared third-party applications.

Examples:

```text
/opt/apps/moderncsv
/opt/apps/drawio
/opt/apps/vendor-tool-name
```

Use this when the application is installed from:

```text
tar.gz
zip
AppImage
manual vendor bundle
standalone binary distribution
```

Recommended ownership:

```text
root:root
```

Recommended permissions:

```text
a+rX
```

## `/opt/projects`

Use `/opt/projects` for shared development repositories and workspaces.

Examples:

```text
/opt/projects/motorweb
/opt/projects/motorhead
/opt/projects/shared-lab-repo
```

Do not install vendor applications here.

Bad:

```text
/opt/projects/moderncsv
```

Good:

```text
/opt/apps/moderncsv
```

## `/usr/local/bin`

Use `/usr/local/bin` for system-wide command launchers, wrappers, or symlinks that should be visible to all users.

Example:

```text
/usr/local/bin/moderncsv -> /opt/apps/moderncsv/moderncsv
```

This allows users to run:

```bash
moderncsv
```

without needing to know the full installation path.

## Package-Managed Applications

Do not manually move package-managed applications into `/opt/apps`.

Leave these under the control of their installer or package manager.

Examples that usually should remain package-managed:

```text
VS Code
pgAdmin4
OBS Studio
Docker Desktop
GitHub Desktop
Google Chrome
Brave Browser
```

Depending on how they were installed, these may be managed by:

```text
apt/dpkg
Flatpak
Snap
vendor installer
```

## JetBrains Toolbox Applications

JetBrains Toolbox manages applications such as PyCharm and IntelliJ IDEA differently.

Do not move Toolbox-managed application directories into `/opt/apps` unless intentionally replacing Toolbox management with a manual shared install model.

Examples:

```text
PyCharm
IntelliJ IDEA
DataGrip
WebStorm
```

Recommended policy:

```text
Keep JetBrains Toolbox-managed tools under Toolbox management.
Document them separately.
Do not force them into /opt/apps just for visual consistency.
```

## GUI Application Testing Standard

CLI tools can often be tested as another user with:

```bash
sudo -iu username
command-name
```

GUI applications should be tested inside the target user's actual desktop session.

Correct GUI validation:

```text
1. Log out of the current user.
2. Log in as the target user from the graphical login screen.
3. Launch the application from the Applications menu.
4. Optionally launch from a terminal opened inside that user's desktop session.
```

Do not assume this proves a broken install:

```bash
sudo -iu bas
gui-application
```

That can fail because user identity and graphical desktop session access are different things.

Common failure symptoms:

```text
Authorization required, but no authorization protocol specified
qt.qpa.xcb: could not connect to display
Could not load the Qt platform plugin "xcb"
```

## Decision Rule

Use this rule when deciding where software belongs:

```text
Package-managed apps stay package-managed.
Self-contained manual apps go under /opt/apps.
Project repos stay under /opt/projects.
Shared command entry points go under /usr/local/bin.
User-specific settings stay under the user's home directory.
```
