#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 || $# -gt 2 ]]; then echo "Usage: sudo bash setup/delete-user.sh <username> [--no-archive]"; exit 1; fi
USERNAME="$1"; NO_ARCHIVE="${2:-}"
case "$USERNAME" in root|pl|bas) echo "ERROR: refusing to delete protected user: $USERNAME"; exit 1;; esac
id "$USERNAME" >/dev/null 2>&1 || { echo "ERROR: user does not exist: $USERNAME"; exit 1; }
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[[ "$NO_ARCHIVE" == "--no-archive" ]] || bash "$REPO_ROOT/setup/archive-user.sh" "$USERNAME"
read -r -p "Type DELETE-$USERNAME to permanently delete this user and home: " CONFIRM
[[ "$CONFIRM" == "DELETE-$USERNAME" ]] || { echo "Delete cancelled."; exit 1; }
userdel -r "$USERNAME"
