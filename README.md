# macify

Personal macOS setup and configuration management.

## What's included

- **Brewfile** — Homebrew packages and applications
- **Aliases** — Shell aliases and git aliases
- **Configs** — Application configuration files
- **Settings** — macOS system preferences and app settings

## Directory structure

```
macify/
├── packages/          # Brewfile and package lists
├── configs/           # Application configuration files
├── aliases/           # Shell and git aliases
├── settings/          # Application settings and preferences
└── scripts/           # Setup and installation scripts
```

## Usage

- **Install packages:** `brew bundle install --file=packages/Brewfile`
- **Restore configs:** Copy from `configs/` to appropriate locations
- **Load aliases:** Source alias files in your shell configuration

## Notes

- Update `.gitignore` to exclude sensitive files (API keys, tokens, etc.)
- Each configuration directory can have its own README for specific setup instructions

