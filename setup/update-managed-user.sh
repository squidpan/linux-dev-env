#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 ]]; then
    echo "Usage: sudo bash setup/update-managed-user.sh <username> <profile> [--dry-run]"
    echo "Profiles: base, dev, tester"
    exit 1
fi

USERNAME="$1"
PROFILE="$2"
DRY_RUN="${3:-}"

if [[ "$DRY_RUN" != "" && "$DRY_RUN" != "--dry-run" ]]; then
    echo "ERROR: optional third argument must be --dry-run"
    exit 1
fi

if ! id "$USERNAME" >/dev/null 2>&1; then
    echo "ERROR: user does not exist: $USERNAME"
    exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
USER_HOME="$(getent passwd "$USERNAME" | cut -d: -f6)"
PROFILE_DIR="$REPO_ROOT/profiles/$PROFILE"

if [[ ! -d "$PROFILE_DIR" ]]; then
    echo "ERROR: profile does not exist: $PROFILE"
    exit 1
fi

run() {
    if [[ "$DRY_RUN" == "--dry-run" ]]; then
        echo "[DRY-RUN] $*"
    else
        "$@"
    fi
}

write_file() {
    local target="$1"
    local content="$2"

    if [[ "$DRY_RUN" == "--dry-run" ]]; then
        echo "[DRY-RUN] write $target"
    else
        printf "%s\n" "$content" > "$target"
    fi
}

echo "Updating managed user:"
echo "  user:    $USERNAME"
echo "  profile: $PROFILE"
echo "  home:    $USER_HOME"
echo "  dry-run: ${DRY_RUN:-no}"

run install -d -o "$USERNAME" -g "$USERNAME" "$USER_HOME/.config/shell"
run install -d -o "$USERNAME" -g "$USERNAME" "$USER_HOME/pjs/repos"
run install -d -o "$USERNAME" -g "$USERNAME" "$USER_HOME/pjs/vaults"
run install -d -o "$USERNAME" -g "$USERNAME" "$USER_HOME/pjs/scripts"
run install -d -o "$USERNAME" -g "$USERNAME" "$USER_HOME/pjs/tmp"
run install -d -o "$USERNAME" -g "$USERNAME" "$USER_HOME/bin"
run install -d -o "$USERNAME" -g "$USERNAME" "$USER_HOME/dotfiles/originals"

if [[ -f "$USER_HOME/.profile" && ! -f "$USER_HOME/dotfiles/originals/profile.original" ]]; then
    run cp "$USER_HOME/.profile" "$USER_HOME/dotfiles/originals/profile.original"
fi

if [[ -f "$USER_HOME/.bashrc" && ! -f "$USER_HOME/dotfiles/originals/bashrc.original" ]]; then
    run cp "$USER_HOME/.bashrc" "$USER_HOME/dotfiles/originals/bashrc.original"
fi

PROFILE_CONTENT='# ~/.profile

[ -f "$HOME/.config/shell/profile.env" ] && \
    source "$HOME/.config/shell/profile.env"

[ -f "$HOME/.config/shell/env.sh" ] && \
    source "$HOME/.config/shell/env.sh"

[ -f "$HOME/.config/shell/paths.sh" ] && \
    source "$HOME/.config/shell/paths.sh"
'

BASHRC_CONTENT='# ~/.bashrc

[ -f "$HOME/.config/shell/aliases.sh" ] && \
    source "$HOME/.config/shell/aliases.sh"

[ -f "$HOME/.config/shell/functions.sh" ] && \
    source "$HOME/.config/shell/functions.sh"

[ -f "$HOME/.config/shell/prompt.sh" ] && \
    source "$HOME/.config/shell/prompt.sh"
'

write_file "$USER_HOME/.profile" "$PROFILE_CONTENT"
write_file "$USER_HOME/.bashrc" "$BASHRC_CONTENT"

if [[ -d "$REPO_ROOT/shell" ]]; then
    for f in "$REPO_ROOT"/shell/*.sh; do
        [[ -f "$f" ]] || continue
        run cp "$f" "$USER_HOME/.config/shell/"
    done
fi

run cp "$PROFILE_DIR/profile.env" "$USER_HOME/.config/shell/profile.env"

if [[ -d "$PROFILE_DIR/bin" ]]; then
    run cp -R "$PROFILE_DIR/bin/." "$USER_HOME/bin/"
fi

if [[ -d "$PROFILE_DIR/skel" ]]; then
    run cp -R "$PROFILE_DIR/skel/." "$USER_HOME/"
fi

run chown -R "$USERNAME:$USERNAME" \
    "$USER_HOME/.profile" \
    "$USER_HOME/.bashrc" \
    "$USER_HOME/.config" \
    "$USER_HOME/pjs" \
    "$USER_HOME/bin" \
    "$USER_HOME/dotfiles"

if [[ -d "$USER_HOME/.ssh" ]]; then
    run chmod 700 "$USER_HOME/.ssh"
    find "$USER_HOME/.ssh" -type f -name "id_*" ! -name "*.pub" -print0 2>/dev/null | while IFS= read -r -d '' keyfile; do
        run chmod 600 "$keyfile"
    done
    find "$USER_HOME/.ssh" -type f -name "*.pub" -print0 2>/dev/null | while IFS= read -r -d '' pubfile; do
        run chmod 644 "$pubfile"
    done
fi

echo "Managed user update complete."
