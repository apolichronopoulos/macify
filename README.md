# macify

Personal macOS setup and configuration management.

## What's included

- **Brewfile** — Homebrew packages and applications
- **Setup scripts** — Installation and configuration scripts
- **Git configuration** — Git aliases and user configuration
- **Shell aliases** — Custom shell aliases

## Directory structure

```
macify/
├── packages/          # Brewfile and package manager lists
├── setup/             # Setup and installation scripts
├── .config/           # Git configuration and shell aliases
├── docs/              # Development guides and documentation
└── .claude/           # Claude Code workspace configuration
```

## Usage

- **Install packages:** `brew bundle install --file=packages/Brewfile`
- **Setup Git configuration:** `setup/git-config.sh` — Copies `.gitconfig` and `.gitconfig-apo` to home directory
- **Setup shell aliases:** `setup/shell-aliases.sh` — Configures shell aliases and environment
- **Setup other tools:** See individual scripts in `setup/` directory

## Guides

- **[Python Development Setup](docs/PYTHON_SETUP.md)** — pyenv, poetry, and pip configuration
- **[Ruby Development Setup](docs/RUBY_SETUP.md)** — rbenv, Bundler, Rails, and RSpec configuration

## Notes

- Sensitive files (API keys, tokens, etc.) are excluded in `.gitignore`
- See `packages/README.md` for detailed Brewfile information

