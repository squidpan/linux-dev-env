#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 2 ]]; then echo "Usage: bash setup/check-managed-user.sh <username> <profile>"; exit 1; fi
USERNAME="$1"; PROFILE="$2"; USER_HOME="$(getent passwd "$USERNAME" | cut -d: -f6 || true)"
[[ -n "$USER_HOME" ]] || { echo "ERROR: user does not exist: $USERNAME"; exit 1; }
for path in "$USER_HOME/.profile" "$USER_HOME/.bashrc" "$USER_HOME/.config/shell/env.sh" "$USER_HOME/.config/shell/profile.env" "$USER_HOME/pjs/repos" "$USER_HOME/bin"; do
  [[ -e "$path" ]] && echo "[OK] $path" || { echo "[FAIL] $path"; exit 1; }
done
echo "User check passed."
