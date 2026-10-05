#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
TARGET="${REPO_DIR}/run.sh"
BIN_DIR="${MACIFY_BIN_DIR:-$HOME/.local/bin}"
LINK="${BIN_DIR}/macify"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Installing 'macify' command...${NC}"
echo ""

mkdir -p "$BIN_DIR"

if [ -L "$LINK" ] && [ "$(readlink "$LINK")" = "$TARGET" ]; then
    echo -e "${YELLOW}⊘${NC} $LINK already points to $TARGET"
elif [ -e "$LINK" ] || [ -L "$LINK" ]; then
    echo -e "${RED}✗${NC} $LINK already exists and points elsewhere, not overwriting"
    echo -e "  Remove it manually and re-run: rm \"$LINK\""
    exit 1
else
    ln -s "$TARGET" "$LINK"
    echo -e "${GREEN}✓${NC} Linked $LINK -> $TARGET"
fi

case ":$PATH:" in
    *":$BIN_DIR:"*)
        echo -e "${GREEN}✓${NC} $BIN_DIR is on your PATH — run: macify"
        ;;
    *)
        echo -e "${YELLOW}⚠${NC} $BIN_DIR is not on your PATH. Add this to ~/.zshrc:"
        echo "  export PATH=\"$BIN_DIR:\$PATH\""
        ;;
esac
