#!/bin/bash

# Exit on error
set -e

echo "🌟 Starting Dotfiles Installation..."

# -------------------------
# 1. Packages to Install
# -------------------------
REQUIRED_PACKAGES=(
  hyprland kitty rofi waybar dunst nwg-look
  neofetch sddm hyprpaper brightnessctl
  ttf-jetbrains-mono ttf-font-awesome
)

echo "📦 Installing required packages..."

for pkg in "${REQUIRED_PACKAGES[@]}"; do
  if ! pacman -Qi $pkg &> /dev/null; then
    echo "Installing $pkg..."
    sudo pacman -S --noconfirm --needed $pkg
  else
    echo "$pkg already installed ✔️"
  fi
done

# -------------------------
# 2. Copy Config Files
# -------------------------
echo "📁 Copying configuration files..."

CONFIG_DIRS=(hypr kitty rofi waybar dunst neofetch hyprpaper)

for dir in "${CONFIG_DIRS[@]}"; do
  echo "➡️ Installing $dir config..."
  mkdir -p "$HOME/.config/$dir"
  cp -r "$dir/"* "$HOME/.config/$dir/"
done

# -------------------------
# 3. Fonts (Optional)
# -------------------------
if [ -d "fonts" ]; then
  echo "🔤 Installing fonts..."
  mkdir -p ~/.local/share/fonts
  cp -r fonts/* ~/.local/share/fonts
  fc-cache -fv
fi

# -------------------------
# 4. Enable SDDM
# -------------------------
echo "🖥️ Enabling SDDM..."
sudo systemctl enable sddm

# -------------------------
# 5. Wallpaper Setup
# -------------------------
if [ -f "$HOME/.config/hyprpaper/hyprpaper.conf" ]; then
  echo "🖼️ Wallpaper setup detected."
else
  echo "⚠️ No hyprpaper.conf found. Set your wallpaper manually later."
fi

# -------------------------
# 6. Done!
# -------------------------
echo "✅ Dotfiles installed successfully!"
echo "💡 Reboot or relogin to start Hyprland."
