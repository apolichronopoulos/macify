# Python Development Setup

Tags: #development #python

## Overview

This guide recommends a setup using **pyenv** for managing Python versions and virtual environments across different projects. Use **Poetry** for projects that need dependency management and packaging.

### Recommended Tools

- **pyenv** — Isolate Python versions per project without polluting system Python
- **pyenv-virtualenv** — Create and manage project-specific virtual environments
- **Poetry** (optional) — Professional dependency management and packaging when you need deterministic builds

---

## Installation

### 1. Install pyenv (Python version manager)

Allows you to install and switch between multiple Python versions on the same machine.

```bash
brew install pyenv
```

Add pyenv to your shell configuration (~/.zshrc or ~/.bashrc):
```bash
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
```

Verify installation:
```bash
pyenv --version
```

### 2. Install pyenv-virtualenv (Virtual environment manager)

Extends pyenv to manage isolated virtual environments with specific Python versions.

```bash
brew install pyenv-virtualenv
```

Add to your shell configuration:
```bash
eval "$(pyenv virtualenv-init -)"
```

---

## Managing Python Versions

### List Available and Installed Versions

```bash
pyenv versions              # Show installed versions (marked with *)
pyenv install --list       # Show all available versions to install
```

### Install a Python Version

```bash
pyenv install 3.11         # Install Python 3.11
pyenv install 3.12         # Install Python 3.12
pyenv versions             # Verify installation
```

### Set Default Python Version

```bash
pyenv global 3.11          # Set system-wide default to 3.11
pyenv global system        # Revert to system Python
```

### Per-Project Python Version

Create a `.python-version` file in your project directory:

```bash
pyenv local 3.12           # Creates .python-version file with "3.12"
cat .python-version        # Verify
```

When you `cd` into that directory, pyenv automatically activates that Python version.

---

## Virtual Environments with pyenv-virtualenv

### Create a Virtual Environment

```bash
# Create virtualenv named 'aoc' using current default Python
pyenv virtualenv aoc

# Create virtualenv named 'aoc2' using specific Python version
pyenv virtualenv 3.12 aoc2
```

### List Virtual Environments

```bash
pyenv virtualenvs          # List all created virtualenvs
```

### Activate Virtual Environment per Project

Create a `.python-version` file to auto-activate on `cd`:

```bash
cd my-project
pyenv local aoc            # Creates .python-version with "aoc"
```

Now when you enter the directory, the `aoc` virtualenv activates automatically.

### Manual Activation

```bash
pyenv activate aoc         # Manually activate
pyenv deactivate           # Deactivate
```

---

## Poetry - Dependency Management (Optional)

Use Poetry when you need:
- Deterministic dependency resolution (exact versions locked)
- Easy package publishing
- Professional project configuration

### What Poetry Manages

Poetry uses two key files:

1. **pyproject.toml** — Declares project metadata and dependencies (similar to package.json)
2. **poetry.lock** — Locks exact versions of all transitive dependencies (auto-generated)

### Installation

```bash
brew install poetry
```

### Initialize a New Project

```bash
poetry init                # Interactive setup, creates pyproject.toml
```

### Working with Dependencies

```bash
poetry install             # Install dependencies from poetry.lock (or pyproject.toml if lock doesn't exist)
poetry add requests        # Add a dependency
poetry add --group dev pytest  # Add dev dependency
poetry lock                # Update lock file without installing
poetry show                # List installed packages
```

### Using Poetry Virtual Environment

Poetry creates its own virtualenv (separate from pyenv-virtualenv):

```bash
poetry shell               # Activate Poetry's virtualenv for the shell session
exit                       # Deactivate

# Or run commands directly without activating:
poetry run python script.py
```

### Check Poetry's Virtual Environment Location

```bash
cd $(poetry config virtualenvs.path)
ls -la                     # View all Poetry virtualenvs
```

### When to Use Poetry vs pyenv-virtualenv

- **pyenv-virtualenv only**: Simple scripts, one-off projects, no external dependencies
- **Poetry**: Projects with multiple dependencies, team projects, published packages

---

## Verification

### Check Which Python Is Active

```bash
which python && which python3 && which pip && which pip3
```

### Display Versions

```bash
python --version
python3 --version
pip --version
pip3 --version
```

---

## Dependency Management

### Using pip (standalone)

For simple projects without Poetry:

```bash
pip list                           # List installed packages
pip show <package>                 # Show package details
pip install <package>              # Install package
pip install --upgrade <package>    # Upgrade package
pip uninstall <package>            # Remove package
pip install -r requirements.txt    # Install from requirements file
pip freeze > requirements.txt      # Generate requirements file
```

### Using Poetry (recommended for team/published projects)

```bash
poetry add requests                # Add dependency (updates pyproject.toml + poetry.lock)
poetry remove requests             # Remove dependency
poetry install                     # Install from poetry.lock (reproducible)
poetry update                      # Update dependencies (regenerates poetry.lock)
```

---

## Workflow Examples

### Example 1: Simple Script with pyenv-virtualenv

```bash
# Create and activate virtualenv
pyenv virtualenv 3.11 my-script
pyenv local my-script

# Install dependencies
pip install requests beautifulsoup4

# Save dependencies
pip freeze > requirements.txt
```

### Example 2: Team Project with Poetry

```bash
# Clone project
git clone <repo>
cd <project>

# pyenv automatically activates from .python-version
# Poetry handles dependencies
poetry install

# Run project
poetry run python main.py

# Or work in shell
poetry shell
python main.py
exit
```

### Example 3: Multiple Python Versions in One Project

```bash
pyenv virtualenv 3.11 project-py311
pyenv virtualenv 3.12 project-py312

# Test with 3.11
pyenv local project-py311
poetry install
poetry run pytest

# Test with 3.12
pyenv local project-py312
poetry install
poetry run pytest
```
