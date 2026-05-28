#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 2 ]]; then echo "Usage: sudo bash setup/install-user-shell.sh <username> <profile>"; exit 1; fi
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bash "$REPO_ROOT/setup/update-managed-user.sh" "$1" "$2"
