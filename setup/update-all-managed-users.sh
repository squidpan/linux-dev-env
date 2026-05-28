#!/usr/bin/env bash
set -euo pipefail

if [[ $# -gt 1 ]]; then
    echo "Usage: sudo bash setup/update-all-managed-users.sh [--dry-run]"
    exit 1
fi

DRY_RUN="${1:-}"

if [[ "$DRY_RUN" != "" && "$DRY_RUN" != "--dry-run" ]]; then
    echo "ERROR: optional argument must be --dry-run"
    exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$REPO_ROOT/profiles/managed-users.csv"

if [[ ! -f "$MANIFEST" ]]; then
    echo "ERROR: manifest not found: $MANIFEST"
    exit 1
fi

while IFS=, read -r username profile; do
    [[ -z "${username// }" ]] && continue
    [[ "$username" =~ ^# ]] && continue

    username="$(echo "$username" | xargs)"
    profile="$(echo "$profile" | xargs)"

    echo
    echo "=== Updating $username as $profile ==="
    bash "$REPO_ROOT/setup/update-managed-user.sh" "$username" "$profile" ${DRY_RUN:+"$DRY_RUN"}
done < "$MANIFEST"

echo
echo "All managed users processed."
