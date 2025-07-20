#!/bin/bash

# Set the directory where all virtual environments will be stored
VENV_HOME="$HOME/.venvs"
ACTION="$1"
ARGUMENT="$2"

# === Show help information ===
help() {
    echo "Usage: venvman <command> [name]"
    echo "Commands:"
    echo "  create <name>      Create a new venv"
    echo "  list               List all venvs"
    echo "  delete <name>      Delete venv"
    echo "  help               Show this help message"
    echo ""
    echo "Activation commands :"
    echo "  vactivate <name>   Activate a virtual environment"
    echo "  vdeactivate        Deactivate current virtual environment"
}

# === Create a new virtual environment ===
create_venv() {
    local name="$1"
    local path="$VENV_HOME/$name"

    if [ -z "$name" ]; then
        echo "Error: You must provide a name. Usage: venvman create <name>"
        return 1
    fi

    if [ -d "$path" ]; then
        echo "Warning: A venv named '$name' already exists at $path"
        echo "Use a different name or delete the existing one."
        return 1
    fi

    echo "Creating virtual environment '$name'..."
    python3 -m venv "$path"
    
    if [ $? -eq 0 ]; then
        echo "Created venv '$name' at $path"
        echo "To activate: vactivate $name"
    else
        echo "Error: Failed to create virtual environment"
        return 1
    fi
}

# === Delete a virtual environment ===
delete_venv() {
    local name="$1"
    local path="$VENV_HOME/$name"

    if [ -z "$name" ]; then
        echo "Error: You must provide the name of the venv to delete. Usage: venvman delete <name>"
        return 1
    fi

    if [ ! -d "$path" ]; then
        echo "Error: Venv '$name' does not exist."
        return 1
    fi

    echo "Deleting venv '$name'..."
    rm -rf "$path"
    echo "Deleted venv '$name'"
}

# === List all virtual environments ===
list_venvs() {
    echo "Available virtual environments:"
    
    if [ ! -d "$VENV_HOME" ]; then
        echo "  (no venv directory found at $VENV_HOME)"
        return 0
    fi
    
    if [ -z "$(ls -A "$VENV_HOME" 2>/dev/null)" ]; then
        echo "  (none found)"
    else
        for venv in "$VENV_HOME"/*; do
            if [ -d "$venv" ]; then
                echo "  $(basename "$venv")"
            fi
        done | sort
    fi
}

# === Generate activation functions for .bashrc ===
generate_activation_functions() {
    cat << 'EOF'

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
EOF
}

# === Install activation functions ===
install_activation() {
    local bashrc="$HOME/.bashrc"
    
    if grep -q "venvman_activate()" "$bashrc" 2>/dev/null; then
        echo "Info: Activation functions already installed"
        return 0
    fi
    
    echo "Installing activation functions to $bashrc..."
    generate_activation_functions >> "$bashrc"
    echo "Activation functions installed"
    echo "Run: source ~/.bashrc"
}

# === Main commands ===
case "$ACTION" in
    create)
        create_venv "$ARGUMENT"
        ;;
    delete)
        delete_venv "$ARGUMENT"
        ;;
    list)
        list_venvs
        ;;
    install-activation)
        install_activation
        ;;
    help|"")
        help
        ;;
    *)
        echo "Error: Unknown command: $ACTION"
        help
        ;;
esac
