# linux-dev-env
# Linux Developer Environment Build — `bas` User

Target system:
- Pop!_OS
- Docker already cleaned/reinstalled
- Rancher Desktop removed
- Existing shared project:
  ```text
  /opt/projects/motorweb
  ```
- Existing workflows:
  - MotorWeb dev
  - mw_notes_job app enhancements
  - Obsidian
  - obsidian-skills-ng
  - Python learning
  - Spring Boot learning
  - VS Code
  - PyCharm via JetBrains Toolbox

Goal:
Build a clean, modular, reproducible Linux developer environment from scratch using a new user:

```text
bas
```

---

# Recommended Final Architecture

```text
/opt/projects/
    motorweb/

~/pjs/
    repos/
    vaults/
    scripts/
    tmp/

~/.config/shell/
    env.sh
    paths.sh
    aliases.sh
    functions.sh
    prompt.sh
```

---

# PHASE 0 — Create Tracking Repo

From `pl`:

```bash
mkdir -p ~/pjs/repos/linux-dev-env
cd ~/pjs/repos/linux-dev-env
git init
```

Suggested structure:

```text
linux-dev-env/
    README.md
    setup/
    shell/
    docs/
```

---

# PHASE 1 — Create User `bas`

From `pl`:

```bash
sudo adduser bas
```

Add sudo:

```bash
sudo usermod -aG sudo bas
```

---

# PHASE 2 — Shared Project Group Setup

Create shared group:

```bash
sudo groupadd projects
```

Add users:

```bash
sudo usermod -aG projects pl
sudo usermod -aG projects bas
```

Assign ownership:

```bash
sudo chgrp -R projects /opt/projects
```

Permissions:

```bash
sudo chmod -R g+rwX /opt/projects
```

Preserve group ownership:

```bash
sudo find /opt/projects -type d -exec chmod g+s {} \;
```

---

# PHASE 3 — Login As `bas`

Either:

```bash
su - bas
```

or graphical login.

---

# PHASE 4 — Create Directory Structure

As `bas`:

```bash
mkdir -p ~/pjs/{repos,vaults,scripts,tmp}
mkdir -p ~/.config/shell
mkdir -p ~/bin
mkdir -p ~/dotfiles/originals
```

---

# PHASE 5 — Backup Default Dotfiles

```bash
cp ~/.profile ~/dotfiles/originals/profile.original
cp ~/.bashrc ~/dotfiles/originals/bashrc.original
```

Optional:

```bash
cp ~/.bash_logout ~/dotfiles/originals/bash_logout.original
```

---

# PHASE 6 — Create Minimal `.profile`

Edit:

```bash
nano ~/.profile
```

Content:

```bash
# ~/.profile

[ -f "$HOME/.config/shell/env.sh" ] && \
    source "$HOME/.config/shell/env.sh"

[ -f "$HOME/.config/shell/paths.sh" ] && \
    source "$HOME/.config/shell/paths.sh"
```

---

# PHASE 7 — Create Minimal `.bashrc`

Edit:

```bash
nano ~/.bashrc
```

Content:

```bash
# ~/.bashrc

[ -f "$HOME/.config/shell/aliases.sh" ] && \
    source "$HOME/.config/shell/aliases.sh"

[ -f "$HOME/.config/shell/functions.sh" ] && \
    source "$HOME/.config/shell/functions.sh"

[ -f "$HOME/.config/shell/prompt.sh" ] && \
    source "$HOME/.config/shell/prompt.sh"
```

---

# PHASE 8 — Create Shell Modules

## env.sh

```bash
nano ~/.config/shell/env.sh
```

Content:

```bash
export PJS_ROOT="$HOME/pjs"

export REPOS_ROOT="$PJS_ROOT/repos"
export VAULTS_ROOT="$PJS_ROOT/vaults"
export SCRIPTS_ROOT="$PJS_ROOT/scripts"

export EDITOR=vim
export BROWSER=google-chrome
```

## paths.sh

```bash
nano ~/.config/shell/paths.sh
```

Content:

```bash
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
```

## aliases.sh

```bash
nano ~/.config/shell/aliases.sh
```

Content:

```bash
alias ll='ls -lah'

alias cdp='cd $PJS_ROOT'
alias cdr='cd $REPOS_ROOT'
alias cdv='cd $VAULTS_ROOT'
alias cds='cd $SCRIPTS_ROOT'
```

## functions.sh

```bash
nano ~/.config/shell/functions.sh
```

Content:

```bash
mkcd() {
    mkdir -p "$1"
    cd "$1"
}
```

## prompt.sh

```bash
nano ~/.config/shell/prompt.sh
```

Content:

```bash
PS1='\u@\h:\w\$ '
```

---

# PHASE 9 — Reload Shell

```bash
source ~/.profile
source ~/.bashrc
```

Verify:

```bash
echo $PJS_ROOT
alias
```

---

# PHASE 10 — Install Core Linux Tools

```bash
sudo apt update
```

Install:

```bash
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

Verify:

```bash
python3 --version
python3.13 --version
```

Expected:

```text
python3       -> 3.10.x
python3.13    -> 3.13.x
```

---

# PHASE 11 — Verify Existing GUI Apps

Test:

```bash
code
```

```bash
google-chrome
```

```bash
obsidian
```

These should already work because they are system-installed.

---

# PHASE 12 — VS Code Setup

Install recommended extensions ONLY:

- Python
- Pylance
- Docker
- GitLens
- Markdown All in One
- YAML

Avoid extension overload.

---

# PHASE 13 — Python 3.13 Workflow

Use explicit Python 3.13 for all venvs.

Example:

```bash
cd ~/pjs/repos
mkdir python313-test
cd python313-test

python3.13 -m venv .venv
source .venv/bin/activate
```

Verify:

```bash
python --version
pip --version
```

Expected:

```text
Python 3.13.x
```

Install package test:

```bash
pip install requests
```

Freeze dependencies:

```bash
pip freeze > requirements.txt
```

Deactivate:

```bash
deactivate
```

IMPORTANT:

Do NOT use:

```bash
python3 -m venv .venv
```

because `python3` currently points to Python 3.10.

Always use:

```bash
python3.13 -m venv .venv
```

---

# PHASE 14 — Docker Verification

Verify Docker:

```bash
docker ps
```

If permission denied:

logout/login again.

Test container:

```bash
docker run hello-world
```

Optional verification:

```bash
docker version
```

---

# PHASE 15 — Git + GitHub SSH

IMPORTANT:

Git configuration and SSH keys are PER USER.

This means:

```text
pl != bas
```

Each Linux user has separate:

- ~/.gitconfig
- ~/.ssh/
- shell environment
- Git identity

This is expected and GOOD.

---

## Configure Git Identity For `bas`

```bash
git config --global user.name "squidpan"
git config --global user.email "squidpan11@gmail.com"
```

Verify:

```bash
git config --global --list
```

---

## Generate SSH Key

```bash
ssh-keygen -t ed25519 -C "bas@pop-os"
```

Accept default location:

```text
/home/bas/.ssh/id_ed25519
```

---

## Start SSH Agent

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

---

## Show Public Key

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy the ENTIRE line beginning with:

```text
ssh-ed25519 AAAA...
```

---

## Add SSH Key To GitHub

Go to:

```text
https://github.com/settings/keys
```

Click:

```text
New SSH key
```

Recommended title:

```text
bas-pop-os-2026
```

Paste the ENTIRE public key.

---

## First GitHub SSH Connection

Test:

```bash
ssh -T git@github.com
```

FIRST TIME ONLY you will see:

```text
The authenticity of host 'github.com' can't be established
```

This is NORMAL.

Type:

```text
yes
```

This stores GitHub server fingerprint into:

```text
~/.ssh/known_hosts
```

Expected success:

```text
Hi squidpan! You've successfully authenticated
```

---

# PHASE 16 — Create First Real Dev Repos

As `bas`:

```bash
cd ~/pjs/repos
```

Clone or create:

```text
linux-dev-env
obsidian-skills-ng
mw_notes_job
python-learning
springboot-learning
```

DO NOT copy old configs wholesale.

Rebuild intentionally.

---

# PHASE 17 — Obsidian Vault Setup

Create test vault:

```bash
mkdir -p ~/pjs/vaults/bas-lab-vault
```

Use this vault for:

- shell notes
- Docker notes
- Python notes
- obsidian-skills-ng experiments
- AI workflow experiments

Keep separate from production vault initially.

---

# PHASE 18 — Create `dev-check` Script

Create:

```bash
nano ~/bin/dev-check
```

Content:

```bash
#!/usr/bin/env bash

echo "--- shell ---"
echo "$SHELL"

echo "--- python ---"
python3.13 --version

echo "--- docker ---"
docker --version

echo "--- git ---"
git --version
```

Make executable:

```bash
chmod +x ~/bin/dev-check
```

Run:

```bash
dev-check
```

---

# PHASE 19 — Create And Push `linux-dev-env`

## Create Local Repo

```bash
cd ~/pjs/repos

mkdir linux-dev-env
cd linux-dev-env

git init
```

---

## Create Initial README

```bash
echo "# linux-dev-env" > README.md
```

---

## First Commit

```bash
git add .
git commit -m "feat: initialize linux developer environment repo"
```

---

## Rename Branch master -> main

```bash
git branch -M main
```

Verify:

```bash
git branch
```

Expected:

```text
* main
```

---

## Create GitHub Repo

Create PUBLIC repo:

```text
linux-dev-env
```

DO NOT initialize with:

- README
- .gitignore
- license

---

## Add Remote

```bash
git remote add origin git@github.com:squidpan/linux-dev-env.git
```

Verify:

```bash
git remote -v
```

---

## Push

```bash
git push -u origin main
```

Expected:

```text
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

---

## Add Shell Configuration To Repo

Create structure:

```bash
mkdir -p shell
mkdir -p docs
mkdir -p setup
```

Copy configs:

```bash
cp ~/.profile shell/profile
cp ~/.bashrc shell/bashrc

cp ~/.config/shell/env.sh shell/
cp ~/.config/shell/paths.sh shell/
cp ~/.config/shell/aliases.sh shell/
cp ~/.config/shell/functions.sh shell/
cp ~/.config/shell/prompt.sh shell/
```

Commit:

```bash
git add .
git commit -m "feat: add shell architecture configuration"
git push
```

---

# Recommended Future Phases (Later)

NOT NOW.

Later add:

- pyenv
- nvm
- tmux customization
- starship prompt
- shell completion
- Docker Compose workflows
- dev containers
- Kubernetes
- CI/CD helpers

Only after the base environment feels stable.

---

# Philosophy

- minimal
- modular
- reproducible
- intentionally built
- version controlled

You are learning:

```text
developer workstation engineering
```

This is a real and valuable engineering skill.

