# Node.js Development Setup

Tags: #development #node #npm

## Overview

This guide recommends a setup using **nvm** for managing Node.js versions
per shell session and per project. Use **npm** (bundled with Node) for
dependency management, or **pnpm**/**yarn** when you need faster installs
or workspace support.

### Recommended Tools

- **nvm** — Isolate Node versions per project without polluting the system Node
- **npm** — Default package manager, bundled with every Node install
- **pnpm** / **yarn** (optional) — Faster, disk-efficient alternatives with built-in monorepo/workspace support

---

## Installation

### 1. Install nvm (Node version manager)

```bash
brew install nvm
```

Add nvm to your shell configuration (~/.zshrc or ~/.bashrc):
```bash
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
```

Verify installation:
```bash
nvm --version
```

---

## Managing Node Versions

### List Available and Installed Versions

```bash
nvm ls                      # Show installed versions (marked with ->)
nvm ls-remote                # Show all available versions to install
nvm ls-remote --lts          # Show only LTS releases
```

### Install a Node Version

```bash
nvm install 24               # Install Node 24
nvm install --lts            # Install latest LTS
nvm ls                        # Verify installation
```

### Switch Versions in the Current Shell

```bash
nvm use 24                   # Use Node 24 for this shell session
nvm current                  # Show the active version
```

### Set the Default Version

```bash
nvm alias default 24         # Always default to Node 24 on a new shell
nvm alias default node       # Always default to the latest installed version
```

### Per-Project Node Version

Create a `.nvmrc` file in your project directory:

```bash
echo "24" > .nvmrc           # Pin this project to Node 24
cat .nvmrc                    # Verify
```

When you `cd` into that directory and run `nvm use` (or `nvm use` is wired
into your shell's `cd` hook), nvm automatically switches to that version.

### Uninstall a Version

```bash
nvm uninstall 20.11.0
```

---

## npm - Package Management

**package.json** — dependencies and scripts (declares project metadata)
**package-lock.json** — locked versions of all transitive dependencies (commit to git)

```bash
npm init                     # Interactive setup, creates package.json
npm install                  # Install dependencies from package-lock.json
npm install express          # Add a dependency
npm install -D eslint        # Add a dev dependency
npm install -g <package>     # Install a CLI tool globally
npm uninstall express        # Remove a dependency
npm update                   # Update dependencies within semver ranges
npm outdated                 # Show which dependencies have newer versions
npm list                     # List installed packages
npm run <script>             # Run a script defined in package.json
npx <package>                # Run a package's CLI without installing it globally
```

---

## pnpm / Yarn (Optional)

Use pnpm or Yarn when you need:
- Faster, disk-efficient installs (pnpm's content-addressable store)
- Native monorepo/workspace support
- Stricter dependency resolution than npm's hoisting

### Installation

```bash
brew install pnpm
# or
brew install yarn
```

### Equivalent Commands

| npm                     | pnpm                    | yarn                 |
|-------------------------|--------------------------|-----------------------|
| `npm install`           | `pnpm install`           | `yarn install`        |
| `npm install express`   | `pnpm add express`       | `yarn add express`    |
| `npm install -D eslint` | `pnpm add -D eslint`     | `yarn add -D eslint`  |
| `npm uninstall express` | `pnpm remove express`    | `yarn remove express` |
| `npm run <script>`      | `pnpm <script>`           | `yarn <script>`       |

---

## Verification

### Check Which Node Is Active

```bash
which node && which npm
```

### Display Versions

```bash
node -v
npm -v
```

---

## Testing & Linting

```bash
# Common test runners
npm install -D jest          # or vitest
npm test

# Linting & formatting
npm install -D eslint prettier
npx eslint .
npx prettier --write .
```

---

## Workflow Examples

### Example 1: Simple Script with nvm

```bash
# Install and use a specific version
nvm install 24
nvm use 24

# Initialize and install dependencies
npm init -y
npm install axios
```

### Example 2: Team Project with .nvmrc

```bash
# Clone project
git clone <repo>
cd <project>

# Pin and switch to the project's Node version
nvm use

# Install dependencies and run
npm install
npm run dev
```

### Example 3: Multiple Node Versions in One Project

```bash
nvm install 20
nvm install 24

# Test with Node 20
nvm use 20
npm test

# Test with Node 24
nvm use 24
npm test
```

---

## Quick Reference

| Task                  | Command                        |
|-----------------------|---------------------------------|
| Node version          | `node -v`                       |
| Install version       | `nvm install 24`                |
| Use version (session) | `nvm use 24`                    |
| Set default version   | `nvm alias default 24`          |
| Pin project version   | `echo "24" > .nvmrc`            |
| Install dependencies  | `npm install`                   |
| Add dependency        | `npm install express`           |
| Run script            | `npm run <script>`              |
| Run tests             | `npm test`                      |
| Lint & fix            | `npx eslint . --fix`            |
