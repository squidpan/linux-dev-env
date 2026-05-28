#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 1 ]]; then echo "Usage: sudo bash setup/create-dev-user.sh <username>"; exit 1; fi
USERNAME="$1"
PROJECT_GROUP="${PROJECT_GROUP:-projects}"
id "$USERNAME" >/dev/null 2>&1 || adduser "$USERNAME"
usermod -aG sudo "$USERNAME"
getent group docker >/dev/null && usermod -aG docker "$USERNAME"
getent group "$PROJECT_GROUP" >/dev/null && usermod -aG "$PROJECT_GROUP" "$USERNAME"
echo "Created/configured dev user: $USERNAME"
