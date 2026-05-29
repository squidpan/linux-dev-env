# ModernCSV Shared Installation

## Purpose

Install ModernCSV as a shared GUI application available to `pl`, `bas`, and future Linux users.

ModernCSV is treated as a manually installed third-party vendor application, not as a project repository.

## Linux Dev Environment Standard

Use this layout:

```text
/opt/apps/moderncsv
```

Do not install ModernCSV under:

```text
/opt/projects
```

Reason:

```text
/opt/apps      = shared installed applications
/opt/projects  = shared repositories and project workspaces
/usr/local/bin = shared command launchers or symlinks
~/.config      = per-user application configuration
```

## Source Archive

The tested archive was:

```text
~/pjs/archives/ModernCSV-Linux-v2.4.2.tar.gz
```

The archive contains a top-level directory:

```text
moderncsv2.4.2/
moderncsv2.4.2/moderncsv
moderncsv2.4.2/uninstall.sh
moderncsv2.4.2/plugins/
```

Because of that top-level directory, installation should use:

```bash
--strip-components=1
```

## Install Location

```text
/opt/apps/moderncsv
```

## Launcher

```text
/usr/local/bin/moderncsv
```

## Desktop Entry

```text
/usr/share/applications/moderncsv.desktop
```

## Ownership and Permissions

Recommended ownership:

```text
root:root
```

Recommended permissions:

```text
a+rX
```

This lets all users read and execute the application while keeping installation maintenance controlled by sudo/admin users.

## Full Install Procedure

Run as `pl`.

### 1. Verify the archive

```bash
cd ~/pjs/archives

ls -lh ModernCSV-Linux-v2.4.2.tar.gz

tar -tzf ModernCSV-Linux-v2.4.2.tar.gz | head -20
```

Expected top-level structure:

```text
moderncsv2.4.2/
moderncsv2.4.2/moderncsv
moderncsv2.4.2/uninstall.sh
moderncsv2.4.2/plugins/
```

### 2. Create `/opt/apps`

```bash
sudo mkdir -p /opt/apps
sudo chown root:root /opt/apps
sudo chmod 755 /opt/apps

ls -ld /opt/apps
```

Expected:

```text
drwxr-xr-x root root /opt/apps
```

### 3. Create the ModernCSV application directory

```bash
sudo mkdir -p /opt/apps/moderncsv
```

### 4. Extract ModernCSV

```bash
sudo tar -xzf \
  ~/pjs/archives/ModernCSV-Linux-v2.4.2.tar.gz \
  -C /opt/apps/moderncsv \
  --strip-components=1
```

Verify:

```bash
find /opt/apps/moderncsv -maxdepth 2 | head -30
```

Expected:

```text
/opt/apps/moderncsv/moderncsv
/opt/apps/moderncsv/uninstall.sh
/opt/apps/moderncsv/plugins
```

### 5. Set ownership

```bash
sudo chown -R root:root /opt/apps/moderncsv
```

### 6. Set permissions

```bash
sudo chmod -R a+rX /opt/apps/moderncsv
```

Verify:

```bash
ls -ld /opt/apps/moderncsv
ls -l /opt/apps/moderncsv/moderncsv
```

### 7. Create the system-wide command

```bash
sudo ln -sf \
  /opt/apps/moderncsv/moderncsv \
  /usr/local/bin/moderncsv
```

Verify:

```bash
which moderncsv
```

Expected:

```text
/usr/local/bin/moderncsv
```

### 8. Create the desktop launcher

```bash
sudo tee /usr/share/applications/moderncsv.desktop >/dev/null <<'DESKTOP_EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Modern CSV
Comment=CSV Editor
Exec=/opt/apps/moderncsv/moderncsv %F
Icon=accessories-text-editor
Terminal=false
Categories=Office;Development;
StartupNotify=true
DESKTOP_EOF
```

Verify:

```bash
grep '^Exec=' /usr/share/applications/moderncsv.desktop
```

Expected:

```text
Exec=/opt/apps/moderncsv/moderncsv %F
```

## Test as `pl`

From the `pl` desktop session:

```bash
which moderncsv
moderncsv
```

ModernCSV should launch.

## Test as `bas`

ModernCSV is a GUI application. Do not validate it by running this from inside `pl`'s graphical session:

```bash
sudo -iu bas
moderncsv
```

That may fail with an X11 or Qt display error such as:

```text
Authorization required, but no authorization protocol specified
qt.qpa.xcb: could not connect to display
```

That error usually means `bas` does not have access to `pl`'s active graphical display session. It does not necessarily mean ModernCSV is installed incorrectly.

Correct validation for GUI applications:

```text
1. Log out of pl.
2. Log in as bas from the Pop!_OS graphical login screen.
3. Open the Applications menu.
4. Search for Modern CSV.
5. Launch Modern CSV.
6. Optionally open a sample CSV file.
7. Confirm the application starts and works as bas.
```

Optional terminal verification from inside the actual `bas` desktop session:

```bash
which moderncsv
moderncsv
```

Expected result:

```text
ModernCSV launches successfully for bas.
```

## Upgrade Procedure

When upgrading to a newer ModernCSV version:

```bash
sudo mv \
  /opt/apps/moderncsv \
  /opt/apps/moderncsv.backup-$(date +%Y%m%d-%H%M%S)

sudo mkdir -p /opt/apps/moderncsv

sudo tar -xzf \
  ~/pjs/archives/ModernCSV-Linux-vX.Y.Z.tar.gz \
  -C /opt/apps/moderncsv \
  --strip-components=1

sudo chown -R root:root /opt/apps/moderncsv
sudo chmod -R a+rX /opt/apps/moderncsv

which moderncsv
moderncsv
```

The launcher usually does not need to change:

```text
/usr/local/bin/moderncsv -> /opt/apps/moderncsv/moderncsv
```

The desktop file usually does not need to change:

```text
/usr/share/applications/moderncsv.desktop
```

## Removal Procedure

```bash
sudo rm -f /usr/local/bin/moderncsv
sudo rm -f /usr/share/applications/moderncsv.desktop
sudo rm -rf /opt/apps/moderncsv
```

## Notes

ModernCSV stores user-specific settings under each user's home directory, usually somewhere under `~/.config` or another per-user application data location. The shared executable lives under `/opt/apps`, but user preferences remain per-user.
