#!/usr/bin/env zsh
#
# Apply macOS system preferences via `defaults write`.
# Interactive: every setting that differs from the target value is shown with
# its current and new value, and is only applied after confirmation.

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

if [ ! -t 0 ]; then
    echo -e "${YELLOW}⚠${NC} This script asks for confirmation on each change; run it in an interactive terminal"
    exit 1
fi

typeset -U restart_apps
needs_logout=0
applied=0

# set_default <description> <domain> <key> <type> <value> <restart: app name | logout>
set_default() {
    local desc="$1" domain="$2" key="$3" type="$4" value="$5" restart="$6"
    local expected="$value" current answer

    # `defaults read` prints booleans as 1/0
    if [ "$type" = "bool" ]; then
        [ "$value" = "true" ] && expected=1 || expected=0
    fi

    current="$(defaults read "$domain" "$key" 2>/dev/null)" || current="<unset>"
    current="${current/#\~/$HOME}"

    if [ "$current" = "$expected" ]; then
        echo -e "  ${YELLOW}⊘${NC} $desc (already set)"
        return
    fi

    echo ""
    echo -e "  ${CYAN}?${NC} $desc"
    echo -e "    ${domain} ${key}: ${current} → ${expected}"
    printf "    Apply? [y/N] "
    read -r answer

    case "$answer" in
        [yY]*)
            defaults write "$domain" "$key" "-$type" "$value"
            echo -e "    ${GREEN}✓${NC} Applied"
            applied=$((applied + 1))
            if [ "$restart" = "logout" ]; then
                needs_logout=1
            else
                restart_apps+=("$restart")
            fi
            ;;
        *)
            echo -e "    ${YELLOW}⊘${NC} Skipped"
            ;;
    esac
}

echo -e "${BLUE}Applying macOS defaults (you'll be asked before each change)...${NC}"
echo ""

echo -e "${BLUE}General${NC}"
set_default "Dark mode" \
    NSGlobalDomain AppleInterfaceStyle string "Dark" logout
set_default "Disable automatic spelling correction" \
    NSGlobalDomain NSAutomaticSpellingCorrectionEnabled bool false logout
set_default "Disable swipe between pages (back/forward)" \
    NSGlobalDomain AppleEnableSwipeNavigateWithScrolls bool false logout
set_default "Menu bar clock: always show the date" \
    com.apple.menuextra.clock ShowDate int 1 logout

echo ""
echo -e "${BLUE}Trackpad${NC}"
set_default "Tap to click" \
    com.apple.AppleMultitouchTrackpad Clicking bool true logout

echo ""
echo -e "${BLUE}Finder${NC}"
set_default "Use list view by default" \
    com.apple.finder FXPreferredViewStyle string "Nlsv" Finder
set_default "Search the current folder by default" \
    com.apple.finder FXDefaultSearchScope string "SCcf" Finder

echo ""
echo -e "${BLUE}Dock${NC}"
set_default "Icon size 64" \
    com.apple.dock tilesize int 64 Dock
set_default "Magnification on hover" \
    com.apple.dock magnification bool true Dock
set_default "Hide recent apps" \
    com.apple.dock show-recents bool false Dock
set_default "Minimize windows into their app icon" \
    com.apple.dock minimize-to-application bool true Dock
set_default "Hot corner bottom-right: Desktop" \
    com.apple.dock wvous-br-corner int 4 Dock
set_default "Hot corner top-right: Notification Center" \
    com.apple.dock wvous-tr-corner int 12 Dock

echo ""
echo -e "${BLUE}Windows${NC}"
set_default "No margins around tiled windows" \
    com.apple.WindowManager EnableTiledWindowMargins bool false logout

echo ""
echo -e "${BLUE}Screenshots${NC}"
set_default "Save screenshots to ~/Desktop/Screenshots" \
    com.apple.screencapture location string "$HOME/Desktop/Screenshots" SystemUIServer
# Only create the folder if screenshots are (now) configured to go there
screenshot_dir="$(defaults read com.apple.screencapture location 2>/dev/null)"
screenshot_dir="${screenshot_dir/#\~/$HOME}"
if [ "$screenshot_dir" = "$HOME/Desktop/Screenshots" ] && [ ! -d "$screenshot_dir" ]; then
    mkdir -p "$screenshot_dir"
    echo -e "    ${GREEN}✓${NC} Created $screenshot_dir"
fi

echo ""
if [ $applied -eq 0 ]; then
    echo -e "${GREEN}No changes applied.${NC}"
    exit 0
fi

echo -e "${GREEN}Applied $applied setting(s).${NC}"

if [ ${#restart_apps} -gt 0 ]; then
    echo ""
    printf "Restart ${restart_apps[*]} now so the changes take effect? [y/N] "
    read -r answer
    case "$answer" in
        [yY]*)
            for app in "${restart_apps[@]}"; do
                killall "$app" &> /dev/null || true
                echo -e "  ${GREEN}✓${NC} Restarted $app"
            done
            ;;
        *)
            echo -e "  ${YELLOW}⊘${NC} Not restarted; changes apply next time they relaunch"
            ;;
    esac
fi

if [ $needs_logout -eq 1 ]; then
    echo ""
    echo -e "${BLUE}Tip:${NC} Some changes take effect after logging out and back in"
fi
