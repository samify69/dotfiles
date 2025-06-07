#!/bin/bash

set -euo pipefail

echo "🌟 Starting Dotfiles Installation..."

# -------------------------
# 1. Required packages list
# -------------------------
PACKAGES=(
  hyprland kitty rofi waybar dunst nwg-look
  neofetch sddm hyprpaper brightnessctl
  ttf-jetbrains-mono ttf-font-awesome
)

echo "📦 Installing packages via pacman..."
for pkg in "${PACKAGES[@]}"; do
  if pacman -Qi "$pkg" &>/dev/null; then
    echo "✅ $pkg is already installed."
  else
    echo "⏳ Installing $pkg..."
    sudo pacman -S --noconfirm --needed "$pkg"
  fi
done

# -------------------------
# 2. Copy config files
# -------------------------
CONFIG_FOLDERS=(hypr kitty rofi waybar dunst neofetch hyprpaper)

echo "📁 Copying configuration files to ~/.config/..."
for folder in "${CONFIG_FOLDERS[@]}"; do
  SRC="./$folder"
  DEST="$HOME/.config/$folder"
  
  if [ -d "$SRC" ]; then
    echo "➡️ Copying $folder configs..."
    mkdir -p "$DEST"
    cp -r "$SRC/"* "$DEST/"
  else
    echo "⚠️ Warning: Config folder '$SRC' not found!"
  fi
done

# -------------------------
# 3. Install fonts (if any)
# -------------------------
if [ -d "./fonts" ]; then
  echo "🔤 Installing fonts..."
  mkdir -p "$HOME/.local/share/fonts"
  cp -r ./fonts/* "$HOME/.local/share/fonts/"
  fc-cache -fv
else
  echo "ℹ️ No fonts directory found. Skipping font installation."
fi

# -------------------------
# 4. Enable SDDM service
# -------------------------
echo "🖥️ Enabling SDDM display manager..."
sudo systemctl enable sddm.service

# -------------------------
# 5. Final message
# -------------------------
echo "✅ Dotfiles installation completed!"
echo "💡 Reboot or log out and back in to start using Hyprland."

exit 0
