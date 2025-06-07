#!/bin/bash

# Define colors for better output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}         EuCaue's Dotfiles Installation Script             ${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}This script will symlink configuration files from this repository${NC}"
echo -e "${YELLOW}to your home directory (~).${NC}"
echo -e "${YELLOW}It will attempt to backup existing files/directories if they conflict.${NC}"
echo ""

# Ask for confirmation
read -p "Do you want to proceed with the installation? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${RED}Installation cancelled.${NC}"
    exit 1
fi

# Determine the source directory (where this script is located)
SCRIPT_DIR=$(dirname "$(realpath "$0")")
DOTFILES_DIR="$SCRIPT_DIR"

# Define backup directory
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo ""
echo -e "${GREEN}1. Creating backup directory: $BACKUP_DIR${NC}"
mkdir -p "$BACKUP_DIR"

# Function to create symbolic links
create_symlink() {
    local source_path="$1"
    local dest_path="$2"
    local type="$3" # e.g., "directory", "file"

    echo -e "${YELLOW}Processing $source_path...${NC}"

    if [ -e "$dest_path" ] || [ -L "$dest_path" ]; then
        echo -e "  ${YELLOW}Existing $type found at $dest_path.${NC}"
        echo -e "  ${YELLOW}Moving to backup: $BACKUP_DIR/$(basename "$dest_path")${NC}"
        mv "$dest_path" "$BACKUP_DIR/"
    fi

    echo -e "  ${GREEN}Creating symlink: $source_path -> $dest_path${NC}"
    ln -sf "$source_path" "$dest_path"
}

echo ""
echo -e "${GREEN}2. Symlinking configuration directories to ~/.config/${NC}"

CONFIG_DIRS=(
    "hypr"
    "waybar"
    "kitty"
    "nvim"
    "rofi"
    "wlogout"
    "swaylock"
    "pipewire"
    "zsh"
    "starship"
    "mako"
    "btop"
)

mkdir -p "$HOME/.config"

for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$DOTFILES_DIR/$dir" ]; then
        create_symlink "$DOTFILES_DIR/$dir" "$HOME/.config/$dir" "directory"
    else
        echo -e "${YELLOW}  Warning: Directory $DOTFILES_DIR/$dir not found. Skipping.${NC}"
    fi
done

echo ""
echo -e "${GREEN}3. Handling Zsh specific files${NC}"
if [ -f "$DOTFILES_DIR/zsh/.zshrc" ]; then
    create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc" "file"
else
    echo -e "${YELLOW}  Warning: .zshrc not found in zsh/ directory. Skipping.${NC}"
fi

# Check for .p10k.zsh if it exists in the repo's zsh directory
if [ -f "$DOTFILES_DIR/zsh/.p10k.zsh" ]; then
    create_symlink "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh" "file"
else
    echo -e "${YELLOW}  Warning: .p10k.zsh not found in zsh/ directory. Skipping.${NC}"
fi

echo ""
echo -e "${GREEN}4. Installing fonts${NC}"
FONT_DIR="$DOTFILES_DIR/fonts"
if [ -d "$FONT_DIR" ]; then
    mkdir -p "$HOME/.local/share/fonts"
    echo -e "  ${GREEN}Copying fonts from $FONT_DIR to $HOME/.local/share/fonts/${NC}"
    cp -r "$FONT_DIR"/* "$HOME/.local/share/fonts/"
    echo -e "  ${GREEN}Rebuilding font cache...${NC}"
    fc-cache -fv
    echo -e "  ${GREEN}Fonts installed and cache rebuilt.${NC}"
else
    echo -e "${YELLOW}  Warning: Fonts directory $FONT_DIR not found. Skipping font installation.${NC}"
fi

echo ""
echo -e "${GREEN}5. Installing themes${NC}"
THEMES_DIR="$DOTFILES_DIR/themes"
if [ -d "$THEMES_DIR" ]; then
    mkdir -p "$HOME/.themes"
    echo -e "  ${GREEN}Copying themes from $THEMES_DIR to $HOME/.themes/${NC}"
    cp -r "$THEMES_DIR"/* "$HOME/.themes/"
    echo -e "  ${GREEN}Themes installed.${NC}"
else
    echo -e "${YELLOW}  Warning: Themes directory $THEMES_DIR not found. Skipping theme installation.${NC}"
fi

echo ""
echo -e "${GREEN}6. Handling scripts${NC}"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"
if [ -d "$SCRIPTS_DIR" ]; then
    create_symlink "$SCRIPTS_DIR" "$HOME/scripts" "directory"
    echo -e "  ${GREEN}Consider adding '$HOME/scripts' to your PATH environment variable.${NC}"
    echo -e "  ${GREEN}Example (add to ~/.profile or ~/.zprofile): export PATH=\"\$HOME/scripts:\$PATH\"${NC}"
else
    echo -e "${YELLOW}  Warning: Scripts directory $SCRIPTS_DIR not found. Skipping script linking.${NC}"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}                 Installation Complete!                    ${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Remember to install the necessary software packages for Hyprland and its components.${NC}"
echo -e "${YELLOW}Here's a list of common dependencies you might need (package names vary by distro):${NC}"
echo -e "${YELLOW}  - Hyprland (the compositor itself)"
echo -e "  - Waybar (status bar)"
echo -e "  - Kitty (terminal emulator)"
echo -e "  - Neovim (text editor)"
echo -e "  - Rofi (application launcher/dmenu replacement)"
echo -e "  - Wlogout (logout menu)"
echo -e "  - Swaylock-effects (screen locker)"
echo -e "  - Cliphist (clipboard manager)"
echo -e "  - Grim (screenshot tool)"
echo -e "  - Slurp (screenshot area selection)"
echo -e "  - Playerctl (media player control)"
echo -e "  - Pamixer (pulseaudio mixer)"
echo -e "  - Btop (system monitor)"
echo -e "  - Nwg-look (GTK theme configurator)"
echo -e "  - Xdg-desktop-portal-hyprland (for screen sharing, etc.)"
echo -e "  - Imagemagick (for various image manipulations)"
echo -e "  - Jq (JSON processor, often used in Waybar scripts)"
echo -e "  - Brightnessctl (screen brightness control)"
echo -e "  - Pipewire, Wireplumber (audio server)"
echo -e "  - Polkit-gnome (authentication agent)"
echo -e "  - Starship (cross-shell prompt)"
echo -e "  - Zsh (shell) and Oh My Zsh (if you prefer it, this repo uses pure zsh with p10k)"
echo -e "  - Mako (notification daemon)"
echo -e "  - Papirus-icon-theme (or your preferred icon theme)${NC}"
echo ""
echo -e "${GREEN}Don't forget to restart your session or reboot for changes to take effect!${NC}"
echo -e "${GREEN}Enjoy your new dotfiles!${NC}"
echo ""
