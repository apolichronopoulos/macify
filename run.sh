#!/usr/bin/env zsh

set -e

# Resolve the repo dir from this script's real path (follows symlinks), so
# run.sh works from any directory and via the `macify` symlink
SCRIPT_DIR="${0:A:h}"
BREWFILE_PATH="${SCRIPT_DIR}/packages/Brewfile"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

show_main_menu() {
    clear
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${BLUE}     Macify - Development Setup${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""
    echo "1) ${GREEN}Brew${NC}"
    echo "2) ${CYAN}Git${NC}"
    echo "3) ${YELLOW}Shell${NC}"
    echo "4) ${BLUE}Docker${NC}"
    echo "5) ${MAGENTA}Versions${NC}"
    echo "6) ${RED}Quit${NC}"
    echo ""
    echo -e "${BLUE}Press ESC to exit${NC}"
    echo ""
}

show_brew_menu() {
    clear
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${GREEN}Brew${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""
    echo "1) ${GREEN}Install${NC} - Install all dependencies from Brewfile"
    echo "2) ${YELLOW}Upgrade${NC} - Upgrade all installed packages"
    echo "3) ${YELLOW}Check${NC} - Check Brewfile for discrepancies"
    echo "4) ${BLUE}Manual Apps${NC} - Show manually installed apps not in Brewfile"
    echo "5) ${BLUE}List${NC} - List all packages in Brewfile"
    echo "6) ${BLUE}Edit${NC} - Open Brewfile in default editor"
    echo "7) ${RED}Back${NC}"
    echo ""
    echo -e "${BLUE}Press ESC to go back${NC}"
    echo ""
}

show_git_menu() {
    clear
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${CYAN}Git${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""
    echo "1) ${BLUE}Config${NC} - Setup Git configurations"
    echo "2) ${BLUE}Apply Aliases${NC} - Apply Git aliases"
    echo "3) ${BLUE}Apply Recommended Settings${NC} - Apply recommended Git options"
    echo "4) ${BLUE}View Aliases${NC} - View all Git aliases"
    echo "5) ${RED}Back${NC}"
    echo ""
    echo -e "${BLUE}Press ESC to go back${NC}"
    echo ""
}

show_shell_menu() {
    clear
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${YELLOW}Shell${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""
    echo "1) ${BLUE}Apply Aliases${NC} - Apply shell aliases to ~/.bashrc and ~/.zshrc"
    echo "2) ${BLUE}View Repo Aliases${NC} - View aliases from the repo"
    echo "3) ${BLUE}View Local Aliases${NC} - View aliases from ~/.bashrc and ~/.zshrc"
    echo "4) ${BLUE}Edit Aliases${NC} - Open shell aliases in editor"
    echo "5) ${GREEN}Install Command${NC} - Install 'macify' command into ~/.local/bin"
    echo "6) ${YELLOW}macOS Defaults${NC} - Apply system preferences (asks before each change)"
    echo "7) ${RED}Back${NC}"
    echo ""
    echo -e "${BLUE}Press ESC to go back${NC}"
    echo ""
}

show_docker_menu() {
    clear
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${BLUE}Docker${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""
    echo "1) ${GREEN}Status${NC} - Show running containers"
    echo "2) ${BLUE}Images${NC} - List all Docker images"
    echo "3) ${GREEN}Compose Up${NC} - Start a project's docker compose"
    echo "4) ${YELLOW}Compose Down${NC} - Stop a project's docker compose"
    echo "5) ${YELLOW}Clean Up${NC} - Remove unused containers, images, volumes, and cache"
    echo "6) ${RED}Back${NC}"
    echo ""
    echo -e "${BLUE}Press ESC to go back${NC}"
    echo ""
}

show_versions_menu() {
    clear
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${MAGENTA}Versions${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""
    echo "1) ${GREEN}pyenv${NC} - Python"
    echo "2) ${RED}rbenv${NC} - Ruby"
    echo "3) ${YELLOW}nvm${NC} - Node"
    echo "4) ${RED}Back${NC}"
    echo ""
    echo -e "${BLUE}Press ESC to go back${NC}"
    echo ""
}

show_pyenv_menu() {
    clear
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${GREEN}pyenv${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""
    echo "1) ${BLUE}Current${NC} - Show global, local, and active version"
    echo "2) ${BLUE}Installed${NC} - List installed versions"
    echo "3) ${BLUE}Available${NC} - List versions available to install"
    echo "4) ${GREEN}Install${NC} - Install a new version"
    echo "5) ${GREEN}Set Global${NC} - Set the global default version"
    echo "6) ${GREEN}Set Local${NC} - Set the version for a project directory"
    echo "7) ${YELLOW}Uninstall${NC} - Remove an installed version"
    echo "8) ${BLUE}Which${NC} - Show resolved paths for pyenv, python, python3, pip, pip3"
    echo "9) ${RED}Back${NC}"
    echo "s) ${GREEN}Setup Shell Init${NC} - Add pyenv init to ~/.zshrc and ~/.bashrc if missing"
    echo ""
    echo -e "${BLUE}Press ESC to go back${NC}"
    echo ""
}

show_rbenv_menu() {
    clear
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${RED}rbenv${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""
    echo "1) ${BLUE}Current${NC} - Show global, local, and active version"
    echo "2) ${BLUE}Installed${NC} - List installed versions"
    echo "3) ${BLUE}Available${NC} - List versions available to install"
    echo "4) ${GREEN}Install${NC} - Install a new version"
    echo "5) ${GREEN}Set Global${NC} - Set the global default version"
    echo "6) ${GREEN}Set Local${NC} - Set the version for a project directory"
    echo "7) ${YELLOW}Uninstall${NC} - Remove an installed version"
    echo "8) ${BLUE}Which${NC} - Show resolved paths for rbenv, ruby, gem, bundle"
    echo "9) ${RED}Back${NC}"
    echo "s) ${GREEN}Setup Shell Init${NC} - Add rbenv init to ~/.zshrc and ~/.bashrc if missing"
    echo ""
    echo -e "${BLUE}Press ESC to go back${NC}"
    echo ""
}

show_nvm_menu() {
    clear
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${YELLOW}nvm${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""
    echo "1) ${BLUE}Current${NC} - Show active, default, and local (.nvmrc) version"
    echo "2) ${BLUE}Installed${NC} - List installed versions"
    echo "3) ${BLUE}Available${NC} - List versions available to install"
    echo "4) ${GREEN}Install${NC} - Install a new version"
    echo "5) ${GREEN}Set Default${NC} - Set the default version (nvm alias default)"
    echo "6) ${GREEN}Set Local${NC} - Write .nvmrc for a project directory and switch"
    echo "7) ${YELLOW}Uninstall${NC} - Remove an installed version"
    echo "8) ${BLUE}Which${NC} - Show resolved paths for nvm, node, npm, npx"
    echo "9) ${RED}Back${NC}"
    echo "s) ${GREEN}Setup Shell Init${NC} - Add nvm init to ~/.zshrc and ~/.bashrc if missing"
    echo ""
    echo -e "${BLUE}Press ESC to go back${NC}"
    echo ""
}

install_packages() {
    echo -e "${GREEN}Installing packages from Brewfile...${NC}"
    brew bundle install --file="${BREWFILE_PATH}"
    echo -e "${GREEN}✓ Installation complete${NC}"
}

upgrade_packages() {
    echo -e "${YELLOW}Upgrading all packages...${NC}"
    brew upgrade
    echo -e "${GREEN}✓ Upgrade complete${NC}"
}

check_brewfile() {
    echo -e "${BLUE}Checking Brewfile status...${NC}"
    if brew bundle check --file="${BREWFILE_PATH}"; then
        echo -e "${GREEN}✓ All dependencies are satisfied${NC}"
    else
        echo -e "${YELLOW}⚠ Some dependencies are missing${NC}"
    fi
}

check_manual_apps() {
    echo -e "${BLUE}Checking Brewfile cask installations...${NC}"
    echo ""

    # Get list of installed cask apps from brew
    local brew_casks=$(brew list --cask 2>/dev/null | sort)

    # Get list of casks mentioned in Brewfile
    local brewfile_casks=$(grep "^cask" "${BREWFILE_PATH}" | sed "s/cask '\([^']*\)'.*/\1/")

    # Get list of .app bundles in /Applications, excluding Contents and Wrapper
    local installed_apps=$(ls -1 /Applications/*.app 2>/dev/null | xargs -n1 basename -s .app | grep -v "^Contents$\|^Wrapper$" | sort)

    echo -e "${BLUE}Brewfile casks status:${NC}"
    echo ""

    while IFS= read -r cask; do
        if echo "$brew_casks" | grep -q "^${cask}$"; then
            echo -e "  ${GREEN}✓${NC} $cask ${GREEN}(installed via brew)${NC}"
        elif echo "$installed_apps" | grep -q "^${cask}$"; then
            echo -e "  ${YELLOW}⚠${NC} $cask ${YELLOW}(installed manually)${NC}"
        else
            echo -e "  ${RED}✗${NC} $cask ${RED}(not installed)${NC}"
        fi
    done <<< "$brewfile_casks"
}

list_packages() {
    echo -e "${BLUE}Packages in Brewfile:${NC}"
    echo ""
    grep -E "^brew|^cask" "${BREWFILE_PATH}" | sed 's/^/  /'
    echo ""
    echo -e "${BLUE}Total:${NC} $(grep -c -E "^brew|^cask" "${BREWFILE_PATH}") packages"
}

docker_status() {
    echo -e "${BLUE}Running containers:${NC}"
    echo ""
    docker ps
}

docker_list_images() {
    echo -e "${BLUE}Docker images:${NC}"
    echo ""
    docker images
}

docker_compose_up() {
    read "?Enter project directory (default: current directory): " project_dir
    project_dir="${project_dir:-.}"

    if [ -f "${project_dir}/docker-compose.yml" ] || [ -f "${project_dir}/docker-compose.yaml" ] || [ -f "${project_dir}/compose.yaml" ]; then
        echo -e "${GREEN}Starting compose project in ${project_dir}...${NC}"
        (cd "${project_dir}" && docker compose up -d)
        echo -e "${GREEN}✓ Compose project started${NC}"
    else
        echo -e "${RED}✗ No compose file found in ${project_dir}${NC}"
    fi
}

docker_compose_down() {
    read "?Enter project directory (default: current directory): " project_dir
    project_dir="${project_dir:-.}"

    if [ -f "${project_dir}/docker-compose.yml" ] || [ -f "${project_dir}/docker-compose.yaml" ] || [ -f "${project_dir}/compose.yaml" ]; then
        echo -e "${YELLOW}Stopping compose project in ${project_dir}...${NC}"
        (cd "${project_dir}" && docker compose down)
        echo -e "${GREEN}✓ Compose project stopped${NC}"
    else
        echo -e "${RED}✗ No compose file found in ${project_dir}${NC}"
    fi
}

docker_cleanup() {
    echo -e "${YELLOW}This removes stopped containers, unused networks, dangling images, and build cache.${NC}"
    read "?Continue? (y/N): " confirm

    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        docker system prune -f
        echo ""
        read "?Also remove unused (not just dangling) images? (y/N): " confirm_images
        if [[ "$confirm_images" == "y" || "$confirm_images" == "Y" ]]; then
            docker image prune -a -f
        fi
        echo ""
        read "?Also remove unused volumes? (y/N): " confirm_volumes
        if [[ "$confirm_volumes" == "y" || "$confirm_volumes" == "Y" ]]; then
            docker volume prune -f
        fi
        echo -e "${GREEN}✓ Cleanup complete${NC}"
    else
        echo -e "${YELLOW}Cleanup cancelled${NC}"
    fi
}

pause() {
    echo ""
    read "?Press Enter to continue... "
}

print_which() {
    local cmd resolved
    for cmd in "$@"; do
        resolved=$(command -v "$cmd" 2>/dev/null) || true
        if [ -n "$resolved" ]; then
            echo -e "  ${GREEN}✓${NC} $(printf '%-10s' "$cmd") ${resolved}"
        else
            echo -e "  ${RED}✗${NC} $(printf '%-10s' "$cmd") not found"
        fi
    done
}

check_tool() {
    local tool="$1"
    local hint="$2"
    if ! command -v "$tool" &> /dev/null; then
        echo -e "${RED}✗ ${tool} not found.${NC} ${hint}"
        return 1
    fi
}

load_nvm() {
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        \. "$NVM_DIR/nvm.sh"
    elif [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
        \. "/opt/homebrew/opt/nvm/nvm.sh"
    else
        echo -e "${RED}✗ nvm not found.${NC} Install with: brew install nvm"
        return 1
    fi
}

# --- pyenv ---

pyenv_current() {
    check_tool pyenv "Install with: brew install pyenv" || return
    echo -e "${BLUE}Global version:${NC}"
    pyenv global
    echo ""
    echo -e "${BLUE}Local version (this directory):${NC}"
    pyenv local 2>/dev/null || echo "  (no local version set)"
    echo ""
    echo -e "${BLUE}Active version:${NC}"
    pyenv version
}

pyenv_list_installed() {
    check_tool pyenv "Install with: brew install pyenv" || return
    echo -e "${BLUE}Installed Python versions:${NC}"
    echo ""
    pyenv versions
}

pyenv_list_available() {
    check_tool pyenv "Install with: brew install pyenv" || return
    read "?Filter (e.g. 3.12, leave empty for all): " filter
    echo -e "${BLUE}Available Python versions:${NC}"
    echo ""
    if [ -n "$filter" ]; then
        pyenv install --list | grep -i "$filter"
    else
        pyenv install --list
    fi
}

pyenv_install_version() {
    check_tool pyenv "Install with: brew install pyenv" || return
    read "?Enter version to install (e.g. 3.12.4): " version
    [ -z "$version" ] && { echo -e "${YELLOW}No version entered${NC}"; return; }
    pyenv install "$version"
    echo -e "${GREEN}✓ Installed Python ${version}${NC}"
}

pyenv_set_global() {
    check_tool pyenv "Install with: brew install pyenv" || return
    echo -e "${BLUE}Installed versions:${NC}"
    pyenv versions
    echo ""
    read "?Enter version to set as global: " version
    [ -z "$version" ] && { echo -e "${YELLOW}No version entered${NC}"; return; }
    pyenv global "$version"
    echo -e "${GREEN}✓ Global Python version set to ${version}${NC}"
    python --version
}

pyenv_set_local() {
    check_tool pyenv "Install with: brew install pyenv" || return
    echo -e "${BLUE}Installed versions:${NC}"
    pyenv versions
    echo ""
    read "?Enter project directory (default: current directory): " project_dir
    project_dir="${project_dir:-.}"
    read "?Enter version to set as local: " version
    [ -z "$version" ] && { echo -e "${YELLOW}No version entered${NC}"; return; }
    (cd "${project_dir}" && pyenv local "$version")
    echo -e "${GREEN}✓ Local Python version set to ${version} in ${project_dir}${NC}"
}

pyenv_uninstall_version() {
    check_tool pyenv "Install with: brew install pyenv" || return
    echo -e "${BLUE}Installed versions:${NC}"
    pyenv versions
    echo ""
    read "?Enter version to uninstall: " version
    [ -z "$version" ] && { echo -e "${YELLOW}No version entered${NC}"; return; }
    read "?Uninstall Python ${version}? (y/N): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        pyenv uninstall "$version"
        echo -e "${GREEN}✓ Uninstalled ${version}${NC}"
    else
        echo -e "${YELLOW}Cancelled${NC}"
    fi
}

pyenv_which() {
    echo -e "${BLUE}Resolved paths:${NC}"
    echo ""
    print_which pyenv python python3 pip pip3
}

pyenv_setup_shell_init() {
    check_tool pyenv "Install with: brew install pyenv" || return
    echo -e "${BLUE}Checking shell configs for pyenv init...${NC}"
    echo ""

    local rc
    for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
        if [ ! -f "$rc" ]; then
            echo -e "  ${YELLOW}⚠${NC} $(basename "$rc") not found, skipping"
            continue
        fi

        if grep -q "pyenv init" "$rc"; then
            echo -e "  ${YELLOW}⊘${NC} $(basename "$rc") already has pyenv init"
            continue
        fi

        {
            echo ""
            echo "# pyenv init"
            echo 'export PATH="$HOME/.pyenv/bin:$PATH"'
            echo 'eval "$(pyenv init -)"'
        } >> "$rc"
        echo -e "  ${GREEN}✓${NC} Added pyenv init to $(basename "$rc")"
    done

    echo ""
    echo -e "${BLUE}Tip:${NC} Restart your shell or run: source ~/.zshrc"
}

# --- rbenv ---

rbenv_current() {
    check_tool rbenv "Install with: brew install rbenv ruby-build" || return
    echo -e "${BLUE}Global version:${NC}"
    rbenv global
    echo ""
    echo -e "${BLUE}Local version (this directory):${NC}"
    rbenv local 2>/dev/null || echo "  (no local version set)"
    echo ""
    echo -e "${BLUE}Active version:${NC}"
    rbenv version
}

rbenv_list_installed() {
    check_tool rbenv "Install with: brew install rbenv ruby-build" || return
    echo -e "${BLUE}Installed Ruby versions:${NC}"
    echo ""
    rbenv versions
}

rbenv_list_available() {
    check_tool rbenv "Install with: brew install rbenv ruby-build" || return
    read "?Filter (e.g. 3.4, leave empty for all): " filter
    echo -e "${BLUE}Available Ruby versions:${NC}"
    echo ""
    if [ -n "$filter" ]; then
        rbenv install -l | grep -i "$filter"
    else
        rbenv install -l
    fi
}

rbenv_install_version() {
    check_tool rbenv "Install with: brew install rbenv ruby-build" || return
    read "?Enter version to install (e.g. 3.4.2): " version
    [ -z "$version" ] && { echo -e "${YELLOW}No version entered${NC}"; return; }
    rbenv install "$version"
    echo -e "${GREEN}✓ Installed Ruby ${version}${NC}"
}

rbenv_set_global() {
    check_tool rbenv "Install with: brew install rbenv ruby-build" || return
    echo -e "${BLUE}Installed versions:${NC}"
    rbenv versions
    echo ""
    read "?Enter version to set as global: " version
    [ -z "$version" ] && { echo -e "${YELLOW}No version entered${NC}"; return; }
    rbenv global "$version"
    echo -e "${GREEN}✓ Global Ruby version set to ${version}${NC}"
    ruby -v
}

rbenv_set_local() {
    check_tool rbenv "Install with: brew install rbenv ruby-build" || return
    echo -e "${BLUE}Installed versions:${NC}"
    rbenv versions
    echo ""
    read "?Enter project directory (default: current directory): " project_dir
    project_dir="${project_dir:-.}"
    read "?Enter version to set as local: " version
    [ -z "$version" ] && { echo -e "${YELLOW}No version entered${NC}"; return; }
    (cd "${project_dir}" && rbenv local "$version")
    echo -e "${GREEN}✓ Local Ruby version set to ${version} in ${project_dir}${NC}"
}

rbenv_uninstall_version() {
    check_tool rbenv "Install with: brew install rbenv ruby-build" || return
    echo -e "${BLUE}Installed versions:${NC}"
    rbenv versions
    echo ""
    read "?Enter version to uninstall: " version
    [ -z "$version" ] && { echo -e "${YELLOW}No version entered${NC}"; return; }
    read "?Uninstall Ruby ${version}? (y/N): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        rbenv uninstall "$version"
        echo -e "${GREEN}✓ Uninstalled ${version}${NC}"
    else
        echo -e "${YELLOW}Cancelled${NC}"
    fi
}

rbenv_which() {
    echo -e "${BLUE}Resolved paths:${NC}"
    echo ""
    print_which rbenv ruby gem bundle
}

rbenv_setup_shell_init() {
    check_tool rbenv "Install with: brew install rbenv ruby-build" || return
    echo -e "${BLUE}Checking shell configs for rbenv init...${NC}"
    echo ""

    local rc
    for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
        if [ ! -f "$rc" ]; then
            echo -e "  ${YELLOW}⚠${NC} $(basename "$rc") not found, skipping"
            continue
        fi

        if grep -q "rbenv init" "$rc"; then
            echo -e "  ${YELLOW}⊘${NC} $(basename "$rc") already has rbenv init"
            continue
        fi

        {
            echo ""
            echo "# rbenv init"
            echo 'export PATH="$HOME/.rbenv/shims:$PATH"'
            echo 'eval "$(rbenv init - zsh)"'
        } >> "$rc"
        echo -e "  ${GREEN}✓${NC} Added rbenv init to $(basename "$rc")"
    done

    echo ""
    echo -e "${BLUE}Tip:${NC} Restart your shell or run: source ~/.zshrc"
}

# --- nvm ---

nvm_current() {
    load_nvm || return
    echo -e "${BLUE}Active version:${NC}"
    nvm current
    echo ""
    echo -e "${BLUE}Default alias:${NC}"
    nvm alias default
    echo ""
    echo -e "${BLUE}Local version (.nvmrc in this directory):${NC}"
    if [ -f ".nvmrc" ]; then
        cat .nvmrc
    else
        echo "  (no .nvmrc found)"
    fi
}

nvm_list_installed() {
    load_nvm || return
    echo -e "${BLUE}Installed Node versions:${NC}"
    echo ""
    nvm list
}

nvm_list_available() {
    load_nvm || return
    read "?Filter (e.g. 20, leave empty for LTS releases): " filter
    echo -e "${BLUE}Available Node versions:${NC}"
    echo ""
    if [ -n "$filter" ]; then
        nvm ls-remote | grep -i "$filter"
    else
        nvm ls-remote --lts
    fi
}

nvm_install_version() {
    load_nvm || return
    read "?Enter version to install (e.g. 24, or --lts): " version
    [ -z "$version" ] && { echo -e "${YELLOW}No version entered${NC}"; return; }
    nvm install "$version"
    echo -e "${GREEN}✓ Installed Node ${version}${NC}"
}

nvm_set_default() {
    load_nvm || return
    echo -e "${BLUE}Installed versions:${NC}"
    nvm list
    echo ""
    read "?Enter version to set as default (e.g. 24, or 'node' for latest installed): " version
    [ -z "$version" ] && { echo -e "${YELLOW}No version entered${NC}"; return; }
    nvm alias default "$version"
    nvm use default
    echo -e "${GREEN}✓ Default Node version set to ${version}${NC}"
    node -v
}

nvm_set_local() {
    load_nvm || return
    echo -e "${BLUE}Installed versions:${NC}"
    nvm list
    echo ""
    read "?Enter project directory (default: current directory): " project_dir
    project_dir="${project_dir:-.}"
    read "?Enter version for .nvmrc: " version
    [ -z "$version" ] && { echo -e "${YELLOW}No version entered${NC}"; return; }
    echo "$version" > "${project_dir}/.nvmrc"
    (cd "${project_dir}" && nvm use)
    echo -e "${GREEN}✓ Wrote ${version} to ${project_dir}/.nvmrc and switched${NC}"
}

nvm_uninstall_version() {
    load_nvm || return
    echo -e "${BLUE}Installed versions:${NC}"
    nvm list
    echo ""
    read "?Enter version to uninstall: " version
    [ -z "$version" ] && { echo -e "${YELLOW}No version entered${NC}"; return; }
    read "?Uninstall Node ${version}? (y/N): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        nvm uninstall "$version"
        echo -e "${GREEN}✓ Uninstalled ${version}${NC}"
    else
        echo -e "${YELLOW}Cancelled${NC}"
    fi
}

nvm_which() {
    load_nvm &> /dev/null || true
    echo -e "${BLUE}Resolved paths:${NC}"
    echo ""
    print_which nvm node npm npx
}

nvm_setup_shell_init() {
    if [ ! -s "$HOME/.nvm/nvm.sh" ] && [ ! -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
        echo -e "${RED}✗ nvm not found.${NC} Install with: brew install nvm"
        return
    fi
    echo -e "${BLUE}Checking shell configs for nvm init...${NC}"
    echo ""

    local rc
    for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
        if [ ! -f "$rc" ]; then
            echo -e "  ${YELLOW}⚠${NC} $(basename "$rc") not found, skipping"
            continue
        fi

        if grep -q "nvm.sh" "$rc"; then
            echo -e "  ${YELLOW}⊘${NC} $(basename "$rc") already has nvm init"
            continue
        fi

        {
            echo ""
            echo "# nvm init"
            echo 'export NVM_DIR="$HOME/.nvm"'
            echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"'
        } >> "$rc"
        echo -e "  ${GREEN}✓${NC} Added nvm init to $(basename "$rc")"
    done

    echo ""
    echo -e "${BLUE}Tip:${NC} Restart your shell or run: source ~/.zshrc"
}

setup_git_config() {
    bash "${SCRIPT_DIR}/setup/git-config.sh"
}

setup_git_aliases() {
    bash "${SCRIPT_DIR}/setup/aliases.sh"
}

setup_git_recommended() {
    zsh "${SCRIPT_DIR}/setup/git-recommended-options.sh"
}

setup_shell_aliases() {
    bash "${SCRIPT_DIR}/setup/shell-aliases.sh"
}

install_macify_command() {
    bash "${SCRIPT_DIR}/setup/install-command.sh"
}

setup_macos_defaults() {
    zsh "${SCRIPT_DIR}/setup/macos-defaults.sh" || true
}

view_shell_aliases() {
    echo -e "${BLUE}Repository Shell Aliases:${NC}"
    echo ""
    cat "${SCRIPT_DIR}/.config/.shell_aliases" | grep -v '^#' | grep -v '^$' | sed 's/^/  /'
}

view_local_shell_aliases() {
    echo -e "${BLUE}Local Shell Aliases${NC}"
    echo ""

    echo -e "${CYAN}~/.zshrc:${NC}"
    if [ -f "$HOME/.zshrc" ]; then
        grep "^alias" "$HOME/.zshrc" 2>/dev/null | sed 's/^/  /' || echo "  (no aliases)"
    else
        echo "  (file not found)"
    fi

    echo ""
    echo -e "${CYAN}~/.bashrc:${NC}"
    if [ -f "$HOME/.bashrc" ]; then
        grep "^alias" "$HOME/.bashrc" 2>/dev/null | sed 's/^/  /' || echo "  (no aliases)"
    else
        echo "  (file not found)"
    fi
}

edit_shell_aliases() {
    echo -e "${BLUE}Opening shell aliases in editor...${NC}"
    ${EDITOR:-nano} "${SCRIPT_DIR}/.config/.shell_aliases"
}

view_git_aliases() {
    echo -e "${BLUE}Git Aliases in Repository:${NC}"
    echo ""
    sed -n '/^\[alias\]/,/^\[/p' "${SCRIPT_DIR}/.config/.gitconfig" | grep -v '^\[' | sed 's/^[[:space:]]*/  /'

    echo ""
    echo -e "${BLUE}Git Aliases Applied Globally:${NC}"
    echo ""
    git config --global --list | grep '^alias\.' | sed 's/^alias\./  /'

    echo ""
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${BLUE}Differences${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""

    # Extract just the alias names
    local repo_names=$(sed -n '/^\[alias\]/,/^\[/p' "${SCRIPT_DIR}/.config/.gitconfig" | grep -v '^\[' | sed 's/^[[:space:]]*//' | cut -d' ' -f1 | sort)
    local global_names=$(git config --global --list | grep '^alias\.' | sed 's/^alias\.//' | cut -d'=' -f1 | sort)

    # Missing from global (in repo but not applied)
    echo -e "${YELLOW}Missing (in repo, not applied globally):${NC}"
    local found_missing=0
    while IFS= read -r alias; do
        if [ -n "$alias" ] && ! echo "$global_names" | grep -q "^${alias}$"; then
            echo -e "  ${YELLOW}⚠${NC} $alias"
            found_missing=1
        fi
    done <<< "$repo_names"
    if [ $found_missing -eq 0 ]; then
        echo -e "  ${GREEN}None${NC}"
    fi

    echo ""

    # Extra in global (applied but not in repo)
    echo -e "${RED}Extra (applied globally, not in repo):${NC}"
    local found_extra=0
    while IFS= read -r alias; do
        if [ -n "$alias" ] && ! echo "$repo_names" | grep -q "^${alias}$"; then
            echo -e "  ${RED}◆${NC} $alias"
            found_extra=1
        fi
    done <<< "$global_names"
    if [ $found_extra -eq 0 ]; then
        echo -e "  ${GREEN}None${NC}"
    fi
}

edit_brewfile() {
    echo -e "${BLUE}Opening Brewfile in editor...${NC}"
    ${EDITOR:-nano} "${BREWFILE_PATH}"
}

main() {
    while true; do
        show_main_menu
        read -k 1 "?Choose a group: " group_choice

        # Check if ESC was pressed
        if [[ "$group_choice" == $'\033' ]]; then
            echo -e "\n${BLUE}Goodbye!${NC}"
            exit 0
        fi
        echo ""

        case $group_choice in
            1)
                handle_brew_menu
                ;;
            2)
                handle_git_menu
                ;;
            3)
                handle_shell_menu
                ;;
            4)
                handle_docker_menu
                ;;
            5)
                handle_versions_menu
                ;;
            6)
                echo -e "${BLUE}Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                echo ""
                ;;
        esac
    done
}

handle_brew_menu() {
    while true; do
        show_brew_menu
        read -k 1 "?Choose an option: " choice

        # Check if ESC was pressed
        if [[ "$choice" == $'\033' ]]; then
            echo ""
            return
        fi
        echo ""

        case $choice in
            1)
                install_packages
                pause
                ;;
            2)
                upgrade_packages
                pause
                ;;
            3)
                check_brewfile
                pause
                ;;
            4)
                check_manual_apps
                pause
                ;;
            5)
                list_packages
                pause
                ;;
            6)
                edit_brewfile
                pause
                ;;
            7)
                return
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                echo ""
                ;;
        esac
    done
}

handle_git_menu() {
    while true; do
        show_git_menu
        read -k 1 "?Choose an option: " choice

        # Check if ESC was pressed
        if [[ "$choice" == $'\033' ]]; then
            echo ""
            return
        fi
        echo ""

        case $choice in
            1)
                setup_git_config
                pause
                ;;
            2)
                setup_git_aliases
                pause
                ;;
            3)
                setup_git_recommended
                pause
                ;;
            4)
                view_git_aliases
                pause
                ;;
            5)
                return
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                echo ""
                ;;
        esac
    done
}

handle_shell_menu() {
    while true; do
        show_shell_menu
        read -k 1 "?Choose an option: " choice

        # Check if ESC was pressed
        if [[ "$choice" == $'\033' ]]; then
            echo ""
            return
        fi
        echo ""

        case $choice in
            1)
                setup_shell_aliases
                pause
                ;;
            2)
                view_shell_aliases
                pause
                ;;
            3)
                view_local_shell_aliases
                pause
                ;;
            4)
                edit_shell_aliases
                pause
                ;;
            5)
                install_macify_command
                pause
                ;;
            6)
                setup_macos_defaults
                pause
                ;;
            7)
                return
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                echo ""
                ;;
        esac
    done
}

handle_docker_menu() {
    while true; do
        show_docker_menu
        read -k 1 "?Choose an option: " choice

        # Check if ESC was pressed
        if [[ "$choice" == $'\033' ]]; then
            echo ""
            return
        fi
        echo ""

        case $choice in
            1)
                docker_status
                pause
                ;;
            2)
                docker_list_images
                pause
                ;;
            3)
                docker_compose_up
                pause
                ;;
            4)
                docker_compose_down
                pause
                ;;
            5)
                docker_cleanup
                pause
                ;;
            6)
                return
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                echo ""
                ;;
        esac
    done
}

handle_versions_menu() {
    while true; do
        show_versions_menu
        read -k 1 "?Choose an option: " choice

        # Check if ESC was pressed
        if [[ "$choice" == $'\033' ]]; then
            echo ""
            return
        fi
        echo ""

        case $choice in
            1)
                handle_pyenv_menu
                ;;
            2)
                handle_rbenv_menu
                ;;
            3)
                handle_nvm_menu
                ;;
            4)
                return
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                echo ""
                ;;
        esac
    done
}

handle_pyenv_menu() {
    while true; do
        show_pyenv_menu
        read -k 1 "?Choose an option: " choice

        # Check if ESC was pressed
        if [[ "$choice" == $'\033' ]]; then
            echo ""
            return
        fi
        echo ""

        case $choice in
            1)
                pyenv_current
                pause
                ;;
            2)
                pyenv_list_installed
                pause
                ;;
            3)
                pyenv_list_available
                pause
                ;;
            4)
                pyenv_install_version
                pause
                ;;
            5)
                pyenv_set_global
                pause
                ;;
            6)
                pyenv_set_local
                pause
                ;;
            7)
                pyenv_uninstall_version
                pause
                ;;
            8)
                pyenv_which
                pause
                ;;
            9)
                return
                ;;
            s)
                pyenv_setup_shell_init
                pause
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                echo ""
                ;;
        esac
    done
}

handle_rbenv_menu() {
    while true; do
        show_rbenv_menu
        read -k 1 "?Choose an option: " choice

        # Check if ESC was pressed
        if [[ "$choice" == $'\033' ]]; then
            echo ""
            return
        fi
        echo ""

        case $choice in
            1)
                rbenv_current
                pause
                ;;
            2)
                rbenv_list_installed
                pause
                ;;
            3)
                rbenv_list_available
                pause
                ;;
            4)
                rbenv_install_version
                pause
                ;;
            5)
                rbenv_set_global
                pause
                ;;
            6)
                rbenv_set_local
                pause
                ;;
            7)
                rbenv_uninstall_version
                pause
                ;;
            8)
                rbenv_which
                pause
                ;;
            9)
                return
                ;;
            s)
                rbenv_setup_shell_init
                pause
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                echo ""
                ;;
        esac
    done
}

handle_nvm_menu() {
    while true; do
        show_nvm_menu
        read -k 1 "?Choose an option: " choice

        # Check if ESC was pressed
        if [[ "$choice" == $'\033' ]]; then
            echo ""
            return
        fi
        echo ""

        case $choice in
            1)
                nvm_current
                pause
                ;;
            2)
                nvm_list_installed
                pause
                ;;
            3)
                nvm_list_available
                pause
                ;;
            4)
                nvm_install_version
                pause
                ;;
            5)
                nvm_set_default
                pause
                ;;
            6)
                nvm_set_local
                pause
                ;;
            7)
                nvm_uninstall_version
                pause
                ;;
            8)
                nvm_which
                pause
                ;;
            9)
                return
                ;;
            s)
                nvm_setup_shell_init
                pause
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                echo ""
                ;;
        esac
    done
}

main "$@"
