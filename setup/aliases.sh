#!/usr/bin/env zsh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/../.config/.gitconfig"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Applying Git aliases...${NC}"
echo ""

count=0

# Extract aliases from config and apply them
while IFS= read -r line; do
    # Skip empty lines
    [ -z "$line" ] && continue

    # Remove leading whitespace
    line="${line#[[:space:]]}"

    # Extract key (everything before first space and =)
    key="${line%%[[:space:]]*}"
    [ -z "$key" ] && continue

    # Extract value (everything after = )
    value="${line#*= }"

    # Apply the alias
    git config --global alias."$key" "$value"
    echo -e "  ${GREEN}✓${NC} git $key"
    ((count++))
done < <(sed -n '/^\[alias\]/,/^\[/p' "$CONFIG_FILE" | grep -v '^\[')

echo ""
if [ $count -gt 0 ]; then
    echo -e "${GREEN}Applied $count git aliases!${NC}"
else
    echo -e "${YELLOW}No aliases found to apply${NC}"
fi

echo ""
echo -e "${BLUE}Tip:${NC} View all aliases with: git config --global --list | grep alias"
