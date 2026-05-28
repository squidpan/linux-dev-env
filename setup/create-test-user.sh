#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 1 ]]; then echo "Usage: sudo bash setup/create-test-user.sh <username>"; exit 1; fi
USERNAME="$1"
PROJECT_GROUP="${PROJECT_GROUP:-projects}"
id "$USERNAME" >/dev/null 2>&1 || adduser "$USERNAME"
getent group "$PROJECT_GROUP" >/dev/null && usermod -aG "$PROJECT_GROUP" "$USERNAME"
echo "Created/configured tester user: $USERNAME"
