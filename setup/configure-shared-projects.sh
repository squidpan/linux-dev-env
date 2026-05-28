#!/usr/bin/env bash
set -euo pipefail
PROJECT_GROUP="${PROJECT_GROUP:-projects}"
PROJECT_ROOT="${PROJECT_ROOT:-/opt/projects}"
if ! getent group "$PROJECT_GROUP" >/dev/null; then groupadd "$PROJECT_GROUP"; fi
mkdir -p "$PROJECT_ROOT"
chgrp -R "$PROJECT_GROUP" "$PROJECT_ROOT"
chmod -R g+rwX "$PROJECT_ROOT"
find "$PROJECT_ROOT" -type d -exec chmod g+s {} \;
echo "Configured $PROJECT_ROOT with group $PROJECT_GROUP"
