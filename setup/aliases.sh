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

# Extract aliases from config and apply them.
# Parsed via `git config`, not sed/bash, so values quoted in the file
# (e.g. containing `!`, `&&`, or spaces) are unquoted correctly instead of
# having their literal quote characters baked into the stored alias value.
while IFS= read -r line; do
    [ -z "$line" ] && continue

    full_key="${line%% *}"      # e.g. alias.master
    value="${line#* }"
    key="${full_key#alias.}"

    git config --global alias."$key" "$value"
    echo -e "  ${GREEN}✓${NC} git $key"
    ((count++))
done < <(git config -f "$CONFIG_FILE" --get-regexp '^alias\.')

echo ""
if [ $count -gt 0 ]; then
    echo -e "${GREEN}Applied $count git aliases!${NC}"
else
    echo -e "${YELLOW}No aliases found to apply${NC}"
fi

echo ""
echo -e "${BLUE}Tip:${NC} View all aliases with: git config --global --list | grep alias"
