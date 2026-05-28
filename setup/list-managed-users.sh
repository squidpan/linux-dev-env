#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$REPO_ROOT/profiles/managed-users.csv"

if [[ ! -f "$MANIFEST" ]]; then
    echo "No managed user manifest found at: $MANIFEST"
    exit 0
fi

printf "%-20s %-12s %-20s\n" "USER" "PROFILE" "EXISTS"
printf "%-20s %-12s %-20s\n" "----" "-------" "------"

while IFS=, read -r username profile; do
    [[ -z "${username// }" ]] && continue
    [[ "$username" =~ ^# ]] && continue

    username="$(echo "$username" | xargs)"
    profile="$(echo "$profile" | xargs)"

    if id "$username" >/dev/null 2>&1; then
        exists="yes"
    else
        exists="no"
    fi

    printf "%-20s %-12s %-20s\n" "$username" "$profile" "$exists"
done < "$MANIFEST"
