#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 2 || $# -gt 3 ]]; then echo "Usage: sudo bash setup/update-managed-user.sh <username> <profile> [--dry-run]"; exit 1; fi
USERNAME="$1"; PROFILE="$2"; DRY_RUN="${3:-}"
[[ "$DRY_RUN" == "" || "$DRY_RUN" == "--dry-run" ]] || { echo "ERROR: optional third argument must be --dry-run"; exit 1; }
id "$USERNAME" >/dev/null 2>&1 || { echo "ERROR: user does not exist: $USERNAME"; exit 1; }
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
USER_HOME="$(getent passwd "$USERNAME" | cut -d: -f6)"
PROFILE_DIR="$REPO_ROOT/profiles/$PROFILE"
[[ -d "$PROFILE_DIR" ]] || { echo "ERROR: profile does not exist: $PROFILE"; exit 1; }
run(){ if [[ "$DRY_RUN" == "--dry-run" ]]; then echo "[DRY-RUN] $*"; else "$@"; fi; }
write_file(){ if [[ "$DRY_RUN" == "--dry-run" ]]; then echo "[DRY-RUN] write $1"; else printf "%s\n" "$2" > "$1"; fi; }
run install -d -o "$USERNAME" -g "$USERNAME" "$USER_HOME/.config/shell" "$USER_HOME/pjs/repos" "$USER_HOME/pjs/vaults" "$USER_HOME/pjs/scripts" "$USER_HOME/pjs/tmp" "$USER_HOME/bin" "$USER_HOME/dotfiles/originals"
[[ -f "$USER_HOME/.profile" && ! -f "$USER_HOME/dotfiles/originals/profile.original" ]] && run cp "$USER_HOME/.profile" "$USER_HOME/dotfiles/originals/profile.original"
[[ -f "$USER_HOME/.bashrc" && ! -f "$USER_HOME/dotfiles/originals/bashrc.original" ]] && run cp "$USER_HOME/.bashrc" "$USER_HOME/dotfiles/originals/bashrc.original"
write_file "$USER_HOME/.profile" '# ~/.profile
[ -f "$HOME/.config/shell/profile.env" ] && source "$HOME/.config/shell/profile.env"
[ -f "$HOME/.config/shell/env.sh" ] && source "$HOME/.config/shell/env.sh"
[ -f "$HOME/.config/shell/paths.sh" ] && source "$HOME/.config/shell/paths.sh"'
write_file "$USER_HOME/.bashrc" '# ~/.bashrc
[ -f "$HOME/.config/shell/aliases.sh" ] && source "$HOME/.config/shell/aliases.sh"
[ -f "$HOME/.config/shell/functions.sh" ] && source "$HOME/.config/shell/functions.sh"
[ -f "$HOME/.config/shell/prompt.sh" ] && source "$HOME/.config/shell/prompt.sh"'
for f in "$REPO_ROOT"/shell/*.sh; do [[ -f "$f" ]] && run cp "$f" "$USER_HOME/.config/shell/"; done
run cp "$PROFILE_DIR/profile.env" "$USER_HOME/.config/shell/profile.env"
run chown -R "$USERNAME:$USERNAME" "$USER_HOME/.profile" "$USER_HOME/.bashrc" "$USER_HOME/.config" "$USER_HOME/pjs" "$USER_HOME/bin" "$USER_HOME/dotfiles"
echo "Managed user update complete."
