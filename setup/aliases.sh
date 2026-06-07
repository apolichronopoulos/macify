#!/usr/bin/env zsh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/../.config/.gitconfig"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Applying Git aliases...${NC}"
echo ""

# Extract aliases from the config file
declare -A aliases

while IFS='=' read -r key value; do
    # Skip empty lines and comments
    [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue

    # Remove leading/trailing whitespace
    key="${key#[[:space:]]}"
    key="${key%[[:space:]]}"
    value="${value#[[:space:]]}"
    value="${value%[[:space:]]}"

    # Remove quotes from value if present
    if [[ "$value" =~ ^\"(.*)\"$ ]]; then
        value="${BASH_REMATCH[1]}"
    fi

    aliases["$key"]="$value"
done < <(grep -A100 '^\[alias\]' "$CONFIG_FILE" | grep -v '^\[' | tail -n +2)

# Apply aliases
count=0
for alias in "${(k)aliases[@]}"; do
    value="${aliases[$alias]}"
    git config --global alias."$alias" "$value"
    echo -e "  ${GREEN}✓${NC} git $alias"
    ((count++))
done

echo ""
if [ $count -gt 0 ]; then
    echo -e "${GREEN}Applied $count git aliases!${NC}"
else
    echo -e "${YELLOW}No aliases found to apply${NC}"
fi

echo ""
echo -e "${BLUE}Tip:${NC} View all aliases with: git config --global --list | grep alias"
