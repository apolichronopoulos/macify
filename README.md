# macify

Personal macOS setup and configuration management.

> **Note:** This is my personal setup, shared as-is. The scripts modify global
> git config and shell files in your home directory (`~/.gitconfig`, `~/.zshrc`,
> etc.) — read them before running, and swap in your own name/email in
> `.config/.gitconfig*`.

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
├── run.sh             # Interactive menu (installable as `macify`)
├── AGENTS.md          # Instructions for AI coding agents
└── LICENSE            # MIT
```

## Usage

- **Interactive menu:** `./run.sh`, or `macify` from anywhere once installed
- **Install the `macify` command:** `setup/install-command.sh` (or Shell → Install Command in the menu) — Symlinks `run.sh` into `~/.local/bin/macify`
- **Install packages:** `brew bundle install --file=packages/Brewfile`
- **Setup Git configuration:** `setup/git-config.sh` — Copies `.gitconfig` and `.gitconfig-apo` to home directory
- **Setup shell aliases:** `setup/shell-aliases.sh` — Configures shell aliases and environment
- **Setup other tools:** See individual scripts in `setup/` directory

## Guides

- **[Python Development Setup](docs/PYTHON_SETUP.md)** — pyenv, poetry, and pip configuration
- **[Ruby Development Setup](docs/RUBY_SETUP.md)** — rbenv, Bundler, Rails, and RSpec configuration
- **[Node.js Development Setup](docs/NODE_SETUP.md)** — nvm, npm, and pnpm/Yarn configuration

## Notes

- Sensitive files (API keys, tokens, etc.) are excluded in `.gitignore`
- See `packages/README.md` for detailed Brewfile information

## License

[MIT](LICENSE)

