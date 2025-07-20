#!/bin/bash

# === Configuration ===
VENV_HOME="$HOME/.venvs"
BIN_DIR="$HOME/bin"
BASHRC="$HOME/.bashrc"
SCRIPT_NAME="venvman"
SCRIPT_PATH="$BIN_DIR/$SCRIPT_NAME"

echo "Starting venvman uninstallation..."

# === 1. Remove ~/.venvs directory ===
if [ -d "$VENV_HOME" ]; then
    read -p "Delete all virtual environments in $VENV_HOME? [y/N]: " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        rm -rf "$VENV_HOME"
        echo "Deleted $VENV_HOME"
    else
        echo "Skipped deleting $VENV_HOME"
    fi
else
    echo "No venv directory found at $VENV_HOME"
fi

# === 2. Remove venvman script from ~/bin ===
if [ -f "$SCRIPT_PATH" ]; then
    rm "$SCRIPT_PATH"
    echo "Removed $SCRIPT_PATH"
else
    echo "No venvman script found at $SCRIPT_PATH"
fi

# === 3. Remove aliases and functions from ~/.bashrc ===
if grep -q 'alias venvman=' "$BASHRC" || grep -q 'venvman_activate()' "$BASHRC"; then
    # Backup .bashrc before editing
    cp "$BASHRC" "$BASHRC.bak"

    # Remove venvman functions (from definition to closing brace)
    sed -i '/^venvman_activate()/,/^}/d' "$BASHRC"
    sed -i '/^venvman_deactivate()/,/^}/d' "$BASHRC"

    # Remove comment lines
    sed -i '/# venvman activation helper functions/d' "$BASHRC"
    sed -i '/# Convenient aliases/d' "$BASHRC"

    # Remove alias lines
    sed -i '/alias venvman=/d' "$BASHRC"
    sed -i '/alias vactivate=/d' "$BASHRC"
    sed -i '/alias vdeactivate=/d' "$BASHRC"

    echo "Removed venvman aliases and functions from $BASHRC"
    echo "A backup was saved as $BASHRC.bak"
else
    echo "No venvman configuration found in $BASHRC"
fi

# === 4. Done ===
echo ""
echo "Uninstallation complete."
echo "To finalize, run: source $BASHRC"
