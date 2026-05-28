#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: sudo bash setup/install-user-shell.sh <username> <profile>"
    echo "Profiles: base, dev, tester"
    exit 1
fi

USERNAME="$1"
PROFILE="$2"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bash "$REPO_ROOT/setup/update-managed-user.sh" "$USERNAME" "$PROFILE"
