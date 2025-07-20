# VENVMAN

Python virtual environment manager.



## Installation

1. Clone or download the venvman files
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
