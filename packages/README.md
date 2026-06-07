# Packages & Homebrew

Setup and management of Homebrew packages and macOS applications.

## Installation

### 1. Install Homebrew (if not already installed)

Run the setup script from the root of the repo:

```bash
./setup/brew.sh
```

This script will:
- Install Homebrew if needed
- Update Homebrew
- Install all packages from the Brewfile

### 2. Manual Installation

If you prefer to install manually:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages
brew bundle install --file=packages/Brewfile

# Or dry-run
brew bundle check --verbose --file="packages/Brewfile"
```

## Brewfile

The `Brewfile` contains:
- **CLI tools** — Essential command-line utilities
- **Development** — Programming language environments
- **Terminal & Shell** — Productivity tools for terminal
- **Applications** — GUI applications installed via Homebrew Cask

## Customizing

Edit `Brewfile` to add or remove packages:

```bash
# List installed packages
brew list

# Add a new package
brew install <package-name>
```

Add a package by force (replace existing Application etc)
```bash
brew reinstall --cask --force google-gemini
brew reinstall --cask --force anydesk
```

## Uninstall

To remove all packages installed from the Brewfile:

```bash
brew bundle cleanup --file=packages/Brewfile
```
