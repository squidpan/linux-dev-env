#!/usr/bin/env bash
set -euo pipefail
DRY_RUN="${1:-}"
[[ $# -le 1 ]] || { echo "Usage: sudo bash setup/update-all-managed-users.sh [--dry-run]"; exit 1; }
[[ "$DRY_RUN" == "" || "$DRY_RUN" == "--dry-run" ]] || { echo "ERROR: optional argument must be --dry-run"; exit 1; }
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$REPO_ROOT/profiles/managed-users.csv"
[[ -f "$MANIFEST" ]] || { echo "ERROR: manifest not found: $MANIFEST"; exit 1; }
while IFS=, read -r username profile; do
  [[ -z "${username// }" || "$username" =~ ^# ]] && continue
  username="$(echo "$username" | xargs)"; profile="$(echo "$profile" | xargs)"
  bash "$REPO_ROOT/setup/update-managed-user.sh" "$username" "$profile" ${DRY_RUN:+"$DRY_RUN"}
done < "$MANIFEST"
