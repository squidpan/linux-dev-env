#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: sudo bash setup/archive-user.sh <username>"
    exit 1
fi

USERNAME="$1"
ARCHIVE_ROOT="${ARCHIVE_ROOT:-/opt/user-archives}"

case "$USERNAME" in
    root|pl|bas)
        echo "ERROR: refusing to archive protected user: $USERNAME"
        exit 1
        ;;
esac

if ! id "$USERNAME" >/dev/null 2>&1; then
    echo "ERROR: user does not exist: $USERNAME"
    exit 1
fi

USER_HOME="$(getent passwd "$USERNAME" | cut -d: -f6)"
STAMP="$(date +%Y%m%d-%H%M%S)"
ARCHIVE_FILE="$ARCHIVE_ROOT/${USERNAME}-${STAMP}.tar.gz"

mkdir -p "$ARCHIVE_ROOT"
tar -czf "$ARCHIVE_FILE" -C "$(dirname "$USER_HOME")" "$(basename "$USER_HOME")"

echo "Archived $USERNAME home to:"
echo "$ARCHIVE_FILE"
