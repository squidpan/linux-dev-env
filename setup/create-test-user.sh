#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: sudo bash setup/create-test-user.sh <username>"
    exit 1
fi

USERNAME="$1"
PROJECT_GROUP="${PROJECT_GROUP:-projects}"

if id "$USERNAME" >/dev/null 2>&1; then
    echo "User already exists: $USERNAME"
else
    adduser "$USERNAME"
fi

# Tester users do not automatically get sudo.
# Add sudo manually only if needed:
# sudo usermod -aG sudo <username>

if getent group "$PROJECT_GROUP" >/dev/null; then
    usermod -aG "$PROJECT_GROUP" "$USERNAME"
fi

echo "Created/configured tester user: $USERNAME"
echo "Next: sudo bash setup/install-user-shell.sh $USERNAME tester"
