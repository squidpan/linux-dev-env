#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: sudo bash setup/create-dev-user.sh <username>"
    exit 1
fi

USERNAME="$1"
PROJECT_GROUP="${PROJECT_GROUP:-projects}"

if id "$USERNAME" >/dev/null 2>&1; then
    echo "User already exists: $USERNAME"
else
    adduser "$USERNAME"
fi

usermod -aG sudo "$USERNAME"

if getent group docker >/dev/null; then
    usermod -aG docker "$USERNAME"
fi

if getent group "$PROJECT_GROUP" >/dev/null; then
    usermod -aG "$PROJECT_GROUP" "$USERNAME"
fi

echo "Created/configured dev user: $USERNAME"
echo "Next: sudo bash setup/install-user-shell.sh $USERNAME dev"
