#!/bin/bash

set -euo pipefail

echo "🌟 Starting Dotfiles Installation..."

# List packages to install
packages=(
  hyprland kitty rofi waybar dunst nwg-look
  neofetch sddm hyprpaper brightnessctl
  ttf-jetbrains-mono ttf-font-awesome
)

echo "📦 Installing packages..."
for pkg in "${packages[@]}"; do
  if pacman -Qi "$pkg" &>/dev/null; then
    echo "✅ $pkg is already installed."
  else
    echo "⏳ Installing $pkg..."
    sudo pacman -S --noconfirm --needed "$pkg"
  fi
done

# Copy config folders
config_folders=(hypr kitty rofi waybar dunst neofetch hyprpaper)

echo "📁 Copying config files..."
for folder in "${config_folders[@]}"; do
  if [ -d "./$folder" ]; then
    mkdir -p "$HOME/.config/$folder"
    cp -r "./$folder/"* "$HOME/.config/$folder/"
    echo "✔ Copied $folder configs."
  else
    echo "⚠️ Folder ./$folder not found, skipping."
  fi
done

# Fonts install
if [ -d "./fonts" ]; then
  echo "🔤 Installing fonts..."
  mkdir -p "$HOME/.local/share/fonts"
  cp -r ./fonts/* "$HOME/.local/share/fonts/"
  fc-cache -fv
else
  echo "ℹ️ No fonts folder found, skipping fonts installation."
fi

# Enable SDDM
echo "🖥️ Enabling SDDM service..."
sudo systemctl enable sddm.service

echo "✅ Installation complete! Reboot or logout to start Hyprland."

exit 0
