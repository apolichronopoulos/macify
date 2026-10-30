#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
BREWFILE="${SCRIPT_DIR}/../packages/Brewfile"
ZPROFILE="$HOME/.zprofile"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Setting up Homebrew...${NC}"
echo ""

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo -e "${GREEN}✓${NC} Homebrew installed"
else
    echo -e "${YELLOW}⊘${NC} Homebrew is already installed, skipping"
fi

# A fresh install isn't on PATH yet (/opt/homebrew on Apple Silicon, /usr/local on Intel)
if ! command -v brew &> /dev/null; then
    for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [ -x "$brew_bin" ]; then
            eval "$("$brew_bin" shellenv)"
            break
        fi
    done
fi

# Make brew available in future login shells
SHELLENV_LINE="eval \"\$($(command -v brew) shellenv)\""
if [ -f "$ZPROFILE" ] && grep -q "brew shellenv" "$ZPROFILE"; then
    echo -e "${YELLOW}⊘${NC} ~/.zprofile already loads Homebrew, skipping"
else
    echo "" >> "$ZPROFILE"
    echo "$SHELLENV_LINE" >> "$ZPROFILE"
    echo -e "${GREEN}✓${NC} Added Homebrew shellenv to ~/.zprofile"
fi

# Update Homebrew
echo ""
echo -e "${BLUE}Updating Homebrew...${NC}"
brew update
echo -e "${GREEN}✓${NC} Homebrew updated"

# Install packages from Brewfile
echo ""
echo -e "${BLUE}Installing packages from Brewfile...${NC}"
brew bundle install --file="$BREWFILE"

echo ""
echo -e "${GREEN}Homebrew setup complete!${NC}"
