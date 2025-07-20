# VENVMAN

Python virtual environment manager.
A simple bash script that can be used to manage python venv environments simply and centrally, Its not a replacement of anaconda , mamba , poetry etc. , It just uses the built in python venv and runs if you are using linux based system or bash, altough if anyone is eager  to help bring support on .zsh or windows open a PR :)

### What it *is*:
- A lightweight wrapper around Python's built-in `venv`.
- Stores all your virtual environments under `~/.venvs`.
- Lets you manage environments with simple commands like:
  - `venvman create <name>`
  - `venvman activate <name>`
  - `venvman delete <name>`
  - `venvman list`
- Easy to install and remove — no dependencies, no magic.

---

### What it *is not*:
- It’s **not** a dependency manager like Poetry or Pipenv.
- It’s **not** a data science platform like Anaconda or Mamba.
- It doesn’t handle `requirements.txt`, `pyproject.toml`, or install packages for you.
- It doesn’t manage Python versions — it just uses the default `python3` on your system.

---

## Installation

1. Clone the repo or download the venvman files
2. Run the setup script:

```bash
chmod +x setup.sh
./setup.sh
```

3. Reload your shell:

```bash
source ~/.bashrc
```

## Usage

### Create a virtual environment
```bash
venvman create myproject
```

### Activate an environment
```bash
vactivate myproject
```

### Deactivate current environment
```bash
vdeactivate
```

### List all environments
```bash
venvman list
```

### Delete an environment
```bash
venvman delete myproject
```

### Get help
```bash
venvman help
```

## Requirements

- Python 3.3+
- Bash shell
- Linux/Unix system

## Uninstallation

To remove venvman:

```bash
./uninstall.sh
```

This will optionally delete all virtual environments and remove venvman from your system.
