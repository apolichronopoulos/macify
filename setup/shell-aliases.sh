#!/usr/bin/env zsh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
ALIASES_FILE="${SCRIPT_DIR}/../.config/.shell_aliases"
HOME_ALIASES="$HOME/.shell_aliases"
BASHRC="$HOME/.bashrc"
ZSHRC="$HOME/.zshrc"
SOURCING_LINE="# Source macify shell aliases"
SOURCE_STATEMENT="source ~/.shell_aliases"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Setting up Shell aliases...${NC}"
echo ""

# Copy or merge aliases file
if [ ! -f "$HOME_ALIASES" ]; then
    cp "$ALIASES_FILE" "$HOME_ALIASES"
    echo -e "${GREEN}✓${NC} Copied aliases to ~/.shell_aliases"
else
    # Merge new aliases from repo file that don't exist in home file
    local merged=0
    while IFS= read -r line; do
        if [ -n "$line" ] && [[ ! "$line" =~ ^# ]] && [[ ! "$line" =~ ^$ ]]; then
            if ! grep -F -q "$line" "$HOME_ALIASES"; then
                echo "$line" >> "$HOME_ALIASES"
                merged=$((merged + 1))
            fi
        fi
    done < "$ALIASES_FILE"

    if [ $merged -gt 0 ]; then
        echo -e "${GREEN}✓${NC} Merged $merged new alias(es) into ~/.shell_aliases"
    else
        echo -e "${YELLOW}⊘${NC} ~/.shell_aliases already has all aliases"
    fi
fi

echo ""

setup_shell_file() {
    local shell_file="$1"
    local shell_name="$2"

    if [ ! -f "$shell_file" ]; then
        echo -e "${YELLOW}⚠${NC} $shell_name not found at $shell_file, skipping"
        return
    fi

    # Check if already sourced
    if grep -q "$SOURCING_LINE" "$shell_file"; then
        echo -e "${YELLOW}⊘${NC} $shell_name already has aliases sourced"
        return
    fi

    # Add source statement
    echo "" >> "$shell_file"
    echo "$SOURCING_LINE" >> "$shell_file"
    echo "$SOURCE_STATEMENT" >> "$shell_file"
    echo -e "${GREEN}✓${NC} Added source to $shell_name"
}

# Setup bashrc
setup_shell_file "$BASHRC" "bashrc"

# Setup zshrc
setup_shell_file "$ZSHRC" "zshrc"

echo ""
echo -e "${GREEN}Shell aliases setup complete!${NC}"
echo -e "${BLUE}Tip:${NC} Run 'source ~/.shell_aliases' or restart your shell to reload aliases"
