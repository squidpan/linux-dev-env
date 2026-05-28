#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: sudo bash setup/delete-user.sh <username> [--no-archive]"
    exit 1
fi

USERNAME="$1"
NO_ARCHIVE="${2:-}"

if [[ "$NO_ARCHIVE" != "" && "$NO_ARCHIVE" != "--no-archive" ]]; then
    echo "ERROR: optional second argument must be --no-archive"
    exit 1
fi

case "$USERNAME" in
    root|pl|bas)
        echo "ERROR: refusing to delete protected user: $USERNAME"
        exit 1
        ;;
esac

if ! id "$USERNAME" >/dev/null 2>&1; then
    echo "ERROR: user does not exist: $USERNAME"
    exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "$NO_ARCHIVE" != "--no-archive" ]]; then
    bash "$REPO_ROOT/setup/archive-user.sh" "$USERNAME"
fi

read -r -p "Type DELETE-$USERNAME to permanently delete this user and home: " CONFIRM

if [[ "$CONFIRM" != "DELETE-$USERNAME" ]]; then
    echo "Delete cancelled."
    exit 1
fi

userdel -r "$USERNAME"

echo "Deleted user: $USERNAME"
