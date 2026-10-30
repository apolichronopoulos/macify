# AGENTS.md

Instructions for AI agents (Claude Code, etc.) working in this repository.

## What this repo is

`macify` is Alexandros's personal macOS setup/dotfiles repo, published
publicly under the MIT license (`LICENSE`). It is **not an
application** — there's no build, no test suite, no CI. It's a collection of
shell scripts, config files, and docs that describe and automate how this
one machine is set up. Changes here are low-risk to the repo itself but can
have real side effects on the host machine and on global git/shell config
once a setup script is run.

## Layout

- `packages/Brewfile` — Homebrew formulae/casks, grouped under `# Comment`
  section headers (Version Managers, CLI Utilities, Browsers, etc.). Keep
  new packages under the right heading; add a new heading only if nothing
  fits.
- `packages/README.md` — usage docs for the Brewfile.
- `setup/*.sh` — standalone scripts, each independently runnable from the
  repo root (they resolve their own `SCRIPT_DIR`). They install/merge things
  into the **user's home directory and global git config** (`~/.gitconfig`,
  `~/.gitconfig-apo`, `~/.shell_aliases`, `~/.zshrc`, `~/.bashrc`, `git
  config --global ...`). Existing files are preserved — scripts check for
  existence/merge rather than overwrite.
- `.config/` — the actual config files that `setup/*.sh` copy out:
  `.gitconfig`, `.gitconfig-apo`, `.shell_aliases`. Treat `.gitconfig` as the
  canonical alias list (`run.sh`'s Git menu reads aliases out of it).
- `run.sh` — an interactive zsh TUI (arrow/number-key menu) wrapping the
  `setup/` scripts and Brewfile for day-to-day use (install/upgrade/check
  packages, apply git/shell config, view diffs between repo and
  globally-applied aliases). It's meant to be run directly in a terminal,
  not scripted.
- `docs/*.md` — standalone reference guides (Python/pyenv/Poetry,
  Ruby/rbenv, Node/nvm setup). These are personal cheat sheets, not
  instructions tied to this repo's own scripts.
- `.idea/` — only the project icons are tracked (`.gitignore` ignores the
  rest of `.idea/` with `!.idea/icon.svg`, `!.idea/.ideaIcon.svg`
  exceptions). `.run/` holds a tracked JetBrains run configuration for
  `run.sh`.
- `.claude/settings.local.json` — local Claude Code settings, ignored via
  the user's global gitignore; never commit it.

## Conventions to follow

- **Shell style**: `setup/*.sh` and `run.sh` use `#!/usr/bin/env zsh`
  (`brew.sh` and `install-command.sh` use `#!/bin/bash`), `set -e` where
  mutation matters, and a shared
  color-code pattern (`GREEN`/`YELLOW`/`BLUE`/`RED`/`CYAN`/`NC` with
  `\033[...]` escapes) plus `✓`/`⚠`/`⊘`/`✗` status glyphs in echoed output.
  Match this style in any new script rather than introducing a different
  logging convention.
- Scripts derive their own directory via
  `SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"` (the
  `:-$0` fallback is needed because zsh doesn't set `BASH_SOURCE`, and
  these scripts run under both bash and zsh) and build paths relative to
  it — don't hardcode absolute paths. `run.sh` is zsh-only and uses
  `${0:A:h}` so it also resolves through the `macify` symlink.
- Scripts are idempotent: check if a target file/config already
  exists/matches before writing, and skip (with a `⊘` message) rather than
  clobber. Preserve this when editing them.
- Brewfile: one `brew`/`cask` per line, grouped under a `#` section comment.
  Keep the file sorted within its existing section groupings, don't
  alphabetize the whole file.
- `README.md`'s "Directory structure" and "Usage" sections should stay in
  sync with reality — update them if you add/remove top-level dirs or
  scripts.

## Safety / things to check before acting

- Running anything in `setup/` or `run.sh`'s menu actions **mutates the real
  machine**: global git config, `~/.gitconfig*`, `~/.zshrc`/`~/.bashrc`,
  `~/.shell_aliases`. Don't run these as a side effect of an unrelated task,
  and confirm with the user before executing them even when asked to "test"
  a script — prefer reading the script or doing a dry run (e.g.
  `brew bundle check`) over actually applying changes, unless the user
  clearly wants the real effect.
- **This repo is public.** Never commit secrets. `.gitignore` already
  excludes `.env*`, `*.key`, `*.pem`, `*.p12` — if you ever see
  credential-shaped content staged, stop and flag it rather than
  committing. Also keep out private details that aren't already public:
  work/employer-internal hostnames, IPs, tokens in URLs, absolute
  `/Users/<name>/...` paths (use `~` instead), or personal data beyond the
  name/email already in `.config/`.
- Don't introduce config that stores credentials in plaintext as the
  primary mechanism; prefer macOS Keychain (`osxkeychain`) or `gh auth`.
- `.config/.gitconfig` contains the user's real name/email and git aliases
  that get copied to `~`. Treat it as the source of truth; don't regenerate
  it from scratch.
- There's no test suite to run. "Verifying" a change here means: re-reading
  the edited script for correctness, and/or running read-only commands
  (`brew bundle check --file=packages/Brewfile`, `git config --global
  --list`) rather than mutating ones.
