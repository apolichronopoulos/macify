#!/usr/bin/env zsh

set -e

BREWFILE_PATH="packages/Brewfile"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

show_main_menu() {
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${BLUE}     Macify - Development Setup${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""
    echo "1) ${GREEN}Brew${NC}"
    echo "2) ${CYAN}Git${NC}"
    echo "3) ${YELLOW}Shell${NC}"
    echo "4) ${RED}Quit${NC}"
    echo ""
    echo -e "${BLUE}Press ESC to exit${NC}"
    echo ""
}

show_brew_menu() {
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
    echo -e "${BLUE}Press ESC to exit${NC}"
    echo ""
}

show_git_menu() {
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
    echo -e "${BLUE}Press ESC to exit${NC}"
    echo ""
}

show_shell_menu() {
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${YELLOW}Shell${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""
    echo "1) ${BLUE}Apply Aliases${NC} - Apply shell aliases to ~/.bashrc and ~/.zshrc"
    echo "2) ${BLUE}View Repo Aliases${NC} - View aliases from the repo"
    echo "3) ${BLUE}View Local Aliases${NC} - View aliases from ~/.bashrc and ~/.zshrc"
    echo "4) ${BLUE}Edit Aliases${NC} - Open shell aliases in editor"
    echo "5) ${RED}Back${NC}"
    echo ""
    echo -e "${BLUE}Press ESC to exit${NC}"
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
            echo -e "\n${BLUE}Goodbye!${NC}"
            exit 0
        fi
        echo ""

        case $choice in
            1)
                install_packages
                return
                ;;
            2)
                upgrade_packages
                return
                ;;
            3)
                check_brewfile
                return
                ;;
            4)
                check_manual_apps
                return
                ;;
            5)
                list_packages
                return
                ;;
            6)
                edit_brewfile
                return
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
            echo -e "\n${BLUE}Goodbye!${NC}"
            exit 0
        fi
        echo ""

        case $choice in
            1)
                setup_git_config
                return
                ;;
            2)
                setup_git_aliases
                return
                ;;
            3)
                setup_git_recommended
                return
                ;;
            4)
                view_git_aliases
                return
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
            echo -e "\n${BLUE}Goodbye!${NC}"
            exit 0
        fi
        echo ""

        case $choice in
            1)
                setup_shell_aliases
                return
                ;;
            2)
                view_shell_aliases
                return
                ;;
            3)
                view_local_shell_aliases
                return
                ;;
            4)
                edit_shell_aliases
                return
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

main "$@"
