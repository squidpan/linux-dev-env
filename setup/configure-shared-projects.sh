#!/usr/bin/env bash
set -euo pipefail

PROJECT_GROUP="${PROJECT_GROUP:-projects}"
PROJECT_ROOT="${PROJECT_ROOT:-/opt/projects}"

echo "Configuring shared project root: $PROJECT_ROOT"
echo "Using group: $PROJECT_GROUP"

if ! getent group "$PROJECT_GROUP" >/dev/null; then
    groupadd "$PROJECT_GROUP"
    echo "Created group: $PROJECT_GROUP"
else
    echo "Group already exists: $PROJECT_GROUP"
fi

mkdir -p "$PROJECT_ROOT"
chgrp -R "$PROJECT_GROUP" "$PROJECT_ROOT"
chmod -R g+rwX "$PROJECT_ROOT"
find "$PROJECT_ROOT" -type d -exec chmod g+s {} \;

echo "Shared project root configured."
echo "Add users with: sudo usermod -aG $PROJECT_GROUP <username>"
