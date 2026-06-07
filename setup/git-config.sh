#!/usr/bin/env zsh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${SCRIPT_DIR}/.config"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Setting up Git configurations...${NC}"
echo ""

# Copy .gitconfig if it doesn't exist
if [ ! -f ~/.gitconfig ]; then
    if [ -f "${CONFIG_DIR}/.gitconfig" ]; then
        cp "${CONFIG_DIR}/.gitconfig" ~/.gitconfig
        echo -e "${GREEN}✓${NC} Copied .gitconfig to ~/"
    else
        echo -e "${YELLOW}⚠${NC} .gitconfig not found in ${CONFIG_DIR}"
    fi
else
    echo -e "${YELLOW}⊘${NC} ~/.gitconfig already exists, skipping"
fi

# Copy .gitconfig-apo if it doesn't exist
if [ ! -f ~/.gitconfig-apo ]; then
    if [ -f "${CONFIG_DIR}/.gitconfig-apo" ]; then
        cp "${CONFIG_DIR}/.gitconfig-apo" ~/.gitconfig-apo
        echo -e "${GREEN}✓${NC} Copied .gitconfig-apo to ~/"
    else
        echo -e "${YELLOW}⚠${NC} .gitconfig-apo not found in ${CONFIG_DIR}"
    fi
else
    echo -e "${YELLOW}⊘${NC} ~/.gitconfig-apo already exists, skipping"
fi

echo ""
echo -e "${GREEN}Git configuration setup complete!${NC}"
