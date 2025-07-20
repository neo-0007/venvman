#!/bin/bash

# === Configuration ===
VENV_HOME="$HOME/.venvs"              
BIN_DIR="$HOME/bin"                  
BASHRC="$HOME/.bashrc"               
SCRIPT_NAME="venvman"                
SCRIPT_SRC="$(pwd)/venvman.sh"       
SCRIPT_DEST="$BIN_DIR/$SCRIPT_NAME" 

echo "Starting venvman setup..."

# === 1. Create ~/.venvs if it doesn't exist ===
if [ ! -d "$VENV_HOME" ]; then
    mkdir -p "$VENV_HOME"
    echo "Created directory for virtual environments at $VENV_HOME"
else
    echo "Virtual environment directory already exists at $VENV_HOME"
fi

# === 2. Create ~/bin if it doesn't exist ===
if [ ! -d "$BIN_DIR" ]; then
    mkdir -p "$BIN_DIR"
    echo "Created ~/bin directory"
fi

# === 3. Copy script to ~/bin/venvman ===
cp "$SCRIPT_SRC" "$SCRIPT_DEST"
chmod +x "$SCRIPT_DEST"
echo "Installed venvman to $SCRIPT_DEST"

# === 4. Add alias to .bashrc if not already present ===
if ! grep -q 'alias venvman=' "$BASHRC"; then
    echo "alias venvman=\"$SCRIPT_DEST\"" >> "$BASHRC"
    echo "Added alias 'venvman' to $BASHRC"
else
    echo "Alias 'venvman' already exists in $BASHRC"
fi

# === 5. Add venvman activation functions and aliases ===
if ! grep -q "venvman_activate()" "$BASHRC"; then
    cat >> "$BASHRC" << 'FUNC_EOF'

# venvman activation helper functions
venvman_activate() {
    if [ -z "$1" ]; then
        echo "Usage: vactivate <venv_name>"
        return 1
    fi
    
    local venv_name="$1"
    local venv_path="$HOME/.venvs/$venv_name/bin/activate"
    
    if [ -f "$venv_path" ]; then
        echo "Activating virtual environment '$venv_name'..."
        source "$venv_path"
    else
        echo "Error: Virtual environment '$venv_name' not found"
        echo "Available environments:"
        if [ -d "$HOME/.venvs" ]; then
            ls "$HOME/.venvs" 2>/dev/null || echo "  (none)"
        else
            echo "  (none)"
        fi
        return 1
    fi
}

venvman_deactivate() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo "Deactivating virtual environment..."
        deactivate
    else
        echo "No virtual environment is currently active"
    fi
}

# Convenient aliases
alias vactivate='venvman_activate'
alias vdeactivate='venvman_deactivate'
FUNC_EOF

    echo "Added venvman activation functions and aliases to $BASHRC"
else
    echo "venvman activation functions already exist in $BASHRC"
fi

# === 6. Prompt user to reload shell ===
echo ""
echo "Setup complete!"
echo "To start using venvman immediately, run:"
echo "   source $BASHRC"
