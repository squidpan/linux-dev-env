# ~/.config/shell/functions.sh

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

dev-check() {
    echo "--- user ---"
    whoami

    echo "--- shell ---"
    echo "$SHELL"

    echo "--- pjs ---"
    echo "$PJS_ROOT"

    echo "--- python ---"
    python3.13 --version 2>/dev/null || echo "python3.13 not found"

    echo "--- git ---"
    git --version

    echo "--- docker ---"
    docker --version 2>/dev/null || echo "docker not found or unavailable"
}
