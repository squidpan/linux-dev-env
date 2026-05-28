#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$REPO_ROOT/profiles/managed-users.csv"
[[ -f "$MANIFEST" ]] || { echo "No managed user manifest found"; exit 0; }
printf "%-20s %-12s %-10s\n" "USER" "PROFILE" "EXISTS"
while IFS=, read -r username profile; do
  [[ -z "${username// }" || "$username" =~ ^# ]] && continue
  username="$(echo "$username" | xargs)"; profile="$(echo "$profile" | xargs)"
  id "$username" >/dev/null 2>&1 && exists=yes || exists=no
  printf "%-20s %-12s %-10s\n" "$username" "$profile" "$exists"
done < "$MANIFEST"
