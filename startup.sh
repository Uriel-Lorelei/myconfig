#!/bin/bash

slow_echo() {
  text="$1"
  delay="${2:-0.05}"
  for ((i=0; i<${#text}; i++)); do
    echo -n "${text:$i:1}"
    sleep "$delay"
  done
  echo
}

install_if_missing() {
  for pkg in "$@"; do
    if ! pacman -Q "$pkg" &>/dev/null; then
      slow_echo "Installing $pkg..."
      sudo pacman -S --noconfirm "$pkg"
    else
      slow_echo "$pkg already installed. Skipping..."
    fi
  done
}

slow_echo "initializing the corruption process . . . . . . . . . . . . . . "

install_if_missing mesa hyprland wayland base-devel wl-clip-persist wlogout fzf tmux htop btop libreoffice-fresh audacious cava xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk gvfs wl-clipboard kitty wofi waybar thunar swww nwg-look power-profiles-daemon mako network-manager-applet mpv feh code pipewire pipewire-pulse pipewire-alsa alsa-utils wireplumber pavucontrol brightnessctl ufw bluez bluez-utils blueman hyprlock

cd

MYCONFIG="$HOME/myconfig"
WALLPAPER="$REPO_DIR/mountain.png"
CONFIG_DIR="$HOME/.config"

if ! command -v yay &> /dev/null; then
  slow_echo "Installing yay..."
  git clone https://aur.archlinux.org/yay.git "$HOME/yay"
  cd "$HOME/yay"
  makepkg -si --noconfirm
  cd ..
  rm -rf "$HOME/yay"
else
  slow_echo "yay already installed."
fi

mkdir -p "$HOME/Pictures"

if ! pgrep -x swww-daemon > /dev/null; then
  slow_echo "Starting swww-daemon..."
  swww-daemon &
  sleep 1  
fi

slow_echo "Setting wallpaper..."
swww img "$WALLPAPER" --transition-type center

slow_echo "removing things that you may or may not need. either way i dont care"
rm -rf "$CONFIG_DIR/waybar" "$CONFIG_DIR/mako" "$CONFIG_DIR/kitty" "$CONFIG_DIR/hypr" "$CONFIG_DIR/nwg-look"

echo "Copying new configs..."
cp -r "$MYCONFIG/waybar" "$CONFIG_DIR/"
cp -r "$MYCONFIG/mako" "$CONFIG_DIR/"
cp -r "$MYCONFIG/kitty" "$CONFIG_DIR/"
cp -r "$MYCONFIG/hypr" "$CONFIG_DIR/"
cp -r "$MYCONFIG/nwg-look" "$CONFIG_DIR/"

slow_echo "replacement over"

sudo pacman -S ttf-jetbrains-mono-nerd

git clone https://github.com/vinceliuice/Graphite-gtk-theme.git
cd Graphite-gtk-theme
chmod +x install.sh
./install.sh -c dark -s standard -s compact -l --tweaks black rimless 

cd ..

yay -S bibata-cursor-theme-bin
yay -S papirus-icon-theme
yay -S papirus-folders
yay -S librewolf-bin

papirus-folders -C black

slow_echo "hahahaha this pc is mine now"

install_if_missing zsh
sudo chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
