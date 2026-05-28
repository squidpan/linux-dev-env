# Bas Bootstrap Guide

This guide builds the `bas` user from scratch.

## Target System

- Pop!_OS
- Docker cleanly installed
- Rancher Desktop removed
- Shared project path:
  ```text
  /opt/projects/motorweb
  ```

## PHASE 0 — Create Tracking Repo

From `pl`:

```bash
mkdir -p ~/pjs/repos/linux-dev-env
cd ~/pjs/repos/linux-dev-env
git init
```

## PHASE 1 — Create User `bas`

```bash
sudo adduser bas
sudo usermod -aG sudo bas
```

## PHASE 2 — Shared Project Group Setup

```bash
sudo groupadd projects
sudo usermod -aG projects pl
sudo usermod -aG projects bas
sudo chgrp -R projects /opt/projects
sudo chmod -R g+rwX /opt/projects
sudo find /opt/projects -type d -exec chmod g+s {} \;
```

## PHASE 3 — Login As `bas`

Use either:

```bash
su - bas
```

or graphical login.

For GUI app testing, use real graphical login.

## PHASE 4 — Create Directory Structure

```bash
mkdir -p ~/pjs/{repos,vaults,scripts,tmp}
mkdir -p ~/.config/shell
mkdir -p ~/bin
mkdir -p ~/dotfiles/originals
```

## PHASE 5 — Backup Default Dotfiles

```bash
cp ~/.profile ~/dotfiles/originals/profile.original
cp ~/.bashrc ~/dotfiles/originals/bashrc.original
cp ~/.bash_logout ~/dotfiles/originals/bash_logout.original 2>/dev/null || true
```

## PHASE 6 — Minimal `.profile`

```bash
cat > ~/.profile <<'EOF'
# ~/.profile

[ -f "$HOME/.config/shell/env.sh" ] && \
    source "$HOME/.config/shell/env.sh"

[ -f "$HOME/.config/shell/paths.sh" ] && \
    source "$HOME/.config/shell/paths.sh"
EOF
```

## PHASE 7 — Minimal `.bashrc`

```bash
cat > ~/.bashrc <<'EOF'
# ~/.bashrc

[ -f "$HOME/.config/shell/aliases.sh" ] && \
    source "$HOME/.config/shell/aliases.sh"

[ -f "$HOME/.config/shell/functions.sh" ] && \
    source "$HOME/.config/shell/functions.sh"

[ -f "$HOME/.config/shell/prompt.sh" ] && \
    source "$HOME/.config/shell/prompt.sh"
EOF
```

## PHASE 8 — Create Shell Modules

```bash
cat > ~/.config/shell/env.sh <<'EOF'
export PJS_ROOT="$HOME/pjs"
export REPOS_ROOT="$PJS_ROOT/repos"
export VAULTS_ROOT="$PJS_ROOT/vaults"
export SCRIPTS_ROOT="$PJS_ROOT/scripts"
export TMP_ROOT="$PJS_ROOT/tmp"

export EDITOR=vim
export BROWSER=google-chrome

export OPT_PROJECTS_ROOT="/opt/projects"
export MOTORWEB_ROOT="$OPT_PROJECTS_ROOT/motorweb"
EOF
```

```bash
cat > ~/.config/shell/paths.sh <<'EOF'
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
EOF
```

```bash
cat > ~/.config/shell/aliases.sh <<'EOF'
alias ll='ls -lah'

alias cdp='cd "$PJS_ROOT"'
alias cdr='cd "$REPOS_ROOT"'
alias cdv='cd "$VAULTS_ROOT"'
alias cds='cd "$SCRIPTS_ROOT"'
alias cdt='cd "$TMP_ROOT"'
alias cdmw='cd "$MOTORWEB_ROOT"'
EOF
```

```bash
cat > ~/.config/shell/functions.sh <<'EOF'
mkcd() {
    mkdir -p "$1"
    cd "$1"
}

venv313() {
    python3.13 -m venv .venv
    source .venv/bin/activate
}

activate-venv() {
    source .venv/bin/activate
}
EOF
```

```bash
cat > ~/.config/shell/prompt.sh <<'EOF'
PS1='\u@\h:\w\$ '
EOF
```

## PHASE 9 — Reload Shell

```bash
source ~/.profile
source ~/.bashrc
echo "$PJS_ROOT"
alias
```

## PHASE 10 — Install Core Tools

```bash
sudo apt update

sudo apt install -y \
    git \
    curl \
    wget \
    build-essential \
    tmux \
    ripgrep \
    fd-find \
    jq \
    tree \
    htop \
    vim \
    python3-pip \
    python3.13-venv
```

## PHASE 11 — Verify GUI Apps

From graphical login as `bas`:

```bash
code
google-chrome
obsidian
```

## PHASE 12 — VS Code Setup

Recommended extensions:

- Python
- Pylance
- Docker
- GitLens
- Markdown All in One
- YAML

## PHASE 13 — Python 3.13 Workflow

```bash
cd ~/pjs/repos
mkdir python313-test
cd python313-test

python3.13 -m venv .venv
source .venv/bin/activate

python --version
pip --version

pip install requests
pip freeze > requirements.txt

deactivate
```

## PHASE 14 — Docker Verification

```bash
docker ps
docker run hello-world
docker version
```

If permission denied, logout/login again.

## PHASE 15 — Git + GitHub SSH

```bash
git config --global user.name "squidpan"
git config --global user.email "squidpan11@gmail.com"

ssh-keygen -t ed25519 -C "bas@pop-os"

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

cat ~/.ssh/id_ed25519.pub
```

Add the public key to GitHub.

Test:

```bash
ssh -T git@github.com
```

Expected:

```text
Hi squidpan! You've successfully authenticated
```

## PHASE 16 — Create First Real Repos

```bash
cd ~/pjs/repos
```

Clone/create:

```text
linux-dev-env
obsidian-skills-ng
mw_notes_job
python-learning
springboot-learning
```

## PHASE 17 — Obsidian Vault Setup

```bash
mkdir -p ~/pjs/vaults/bas-lab-vault
```

## PHASE 18 — Create `dev-check`

```bash
cat > ~/bin/dev-check <<'EOF'
#!/usr/bin/env bash

echo "--- user ---"
whoami

echo "--- shell ---"
echo "$SHELL"

echo "--- python ---"
python3.13 --version

echo "--- docker ---"
docker --version

echo "--- git ---"
git --version
EOF

chmod +x ~/bin/dev-check
dev-check
```

## PHASE 19 — Create/Push linux-dev-env Remote

```bash
cd ~/pjs/repos/linux-dev-env

git add .
git commit -m "feat: initial bas developer environment setup"

git branch -M main
git remote add origin git@github.com:squidpan/linux-dev-env.git
git push -u origin main
```
