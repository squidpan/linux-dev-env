#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: bash setup/check-managed-user.sh <username> <profile>"
    echo "Profiles: base, dev, tester"
    exit 1
fi

USERNAME="$1"
PROFILE="$2"

USER_HOME="$(getent passwd "$USERNAME" | cut -d: -f6 || true)"
failures=0

check() {
    local description="$1"
    local command="$2"

    if eval "$command" >/dev/null 2>&1; then
        echo "[OK]   $description"
    else
        echo "[FAIL] $description"
        failures=$((failures + 1))
    fi
}

if [[ -z "$USER_HOME" ]]; then
    echo "ERROR: user does not exist: $USERNAME"
    exit 1
fi

echo "Checking user: $USERNAME"
echo "Profile: $PROFILE"
echo "Home: $USER_HOME"

check "home exists" "[[ -d '$USER_HOME' ]]"
check "profile exists" "[[ -f '$USER_HOME/.profile' ]]"
check "bashrc exists" "[[ -f '$USER_HOME/.bashrc' ]]"
check "shell config dir exists" "[[ -d '$USER_HOME/.config/shell' ]]"
check "env.sh installed" "[[ -f '$USER_HOME/.config/shell/env.sh' ]]"
check "paths.sh installed" "[[ -f '$USER_HOME/.config/shell/paths.sh' ]]"
check "aliases.sh installed" "[[ -f '$USER_HOME/.config/shell/aliases.sh' ]]"
check "functions.sh installed" "[[ -f '$USER_HOME/.config/shell/functions.sh' ]]"
check "prompt.sh installed" "[[ -f '$USER_HOME/.config/shell/prompt.sh' ]]"
check "profile.env installed" "[[ -f '$USER_HOME/.config/shell/profile.env' ]]"
check "pjs/repos exists" "[[ -d '$USER_HOME/pjs/repos' ]]"
check "pjs/vaults exists" "[[ -d '$USER_HOME/pjs/vaults' ]]"
check "pjs/scripts exists" "[[ -d '$USER_HOME/pjs/scripts' ]]"
check "pjs/tmp exists" "[[ -d '$USER_HOME/pjs/tmp' ]]"
check "bin exists" "[[ -d '$USER_HOME/bin' ]]"

if [[ "$PROFILE" == "dev" ]]; then
    check "dev user in docker group if docker group exists" "(! getent group docker >/dev/null) || id -nG '$USERNAME' | grep -qw docker"
fi

check "user in projects group if projects group exists" "(! getent group projects >/dev/null) || id -nG '$USERNAME' | grep -qw projects"

if [[ $failures -eq 0 ]]; then
    echo "User check passed."
else
    echo "User check failed with $failures issue(s)."
    exit 1
fi
