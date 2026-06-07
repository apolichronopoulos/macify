#!/usr/bin/env zsh

set -e

BREWFILE_PATH="packages/Brewfile"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_menu() {
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${BLUE}     Macify - Development Setup${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""
    echo "1) ${GREEN}Install${NC} - Install all dependencies from Brewfile"
    echo "2) ${YELLOW}Upgrade${NC} - Upgrade all installed packages"
    echo "3) ${YELLOW}Check${NC} - Check Brewfile for discrepancies"
    echo "4) ${BLUE}Manual Apps${NC} - Show manually installed apps not in Brewfile"
    echo "5) ${BLUE}List${NC} - List all packages in Brewfile"
    echo "6) ${BLUE}Edit${NC} - Open Brewfile in default editor"
    echo "7) ${RED}Quit${NC}"
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

edit_brewfile() {
    echo -e "${BLUE}Opening Brewfile in editor...${NC}"
    ${EDITOR:-nano} "${BREWFILE_PATH}"
}

main() {
    show_menu
    read -k 1 "?Choose an option (1-7): " choice
    echo ""

    # Check if ESC was pressed
    if [ "$choice" = $'\033' ]; then
        echo -e "${BLUE}Goodbye!${NC}"
        exit 0
    fi

    case $choice in
        1)
            install_packages
            ;;
        2)
            upgrade_packages
            ;;
        3)
            check_brewfile
            ;;
        4)
            check_manual_apps
            ;;
        5)
            list_packages
            ;;
        6)
            edit_brewfile
            ;;
        7)
            echo -e "${BLUE}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            exit 1
            ;;
    esac
}

main "$@"
