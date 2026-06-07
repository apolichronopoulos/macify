#!/usr/bin/env zsh

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Applying recommended Git configurations...${NC}"
echo ""

git config --global core.editor nano
echo -e "${GREEN}✓${NC} Set core.editor to nano"

git config --global credential.helper store
echo -e "${GREEN}✓${NC} Set credential.helper to store"

git config --global fetch.prune true
echo -e "${GREEN}✓${NC} Enabled fetch.prune (auto-prune stale remote branches)"

git config --global merge.conflictstyle diff3
echo -e "${GREEN}✓${NC} Set merge.conflictstyle to diff3 (shows more context)"

git config --global pull.rebase true
echo -e "${GREEN}✓${NC} Enabled pull.rebase (rebase instead of merge on pull)"

git config --global push.autoSetupRemote true
echo -e "${GREEN}✓${NC} Enabled push.autoSetupRemote (auto-setup tracking branch)"

git config --global push.default current
echo -e "${GREEN}✓${NC} Set push.default to current (push to branch with same name)"

echo ""
echo -e "${GREEN}Recommended Git settings applied!${NC}"
