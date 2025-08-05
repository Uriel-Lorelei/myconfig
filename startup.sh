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

install_if_missing mesa hyprland wayland base-devel xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk wl-clipboard kitty wofi waybar thunar swww nwg-look power-profiles-daemon mako network-manager-applet mpv feh code pipewire pipewire-pulse pipewire-alsa alsa-utils wireplumber pavucontrol brightnessctl ufw bluez bluez-utils blueman hyprlock

cd

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

mkdir -p "$HOME/Pictures"
cd myconfig/
mv mountain.png "$HOME/Pictures"
cd ..
swww img "Pictures/mountain"

rm -rf "$HOME/.config/waybar"
rm -rf "$HOME/.config/mako"
rm -rf "$HOME/.config/kitty"
rm -rf "$HOME/.config/nwg-look"

cd myconfig/
mv waybar/ "$HOME/.config/waybar"
cp mako/ "$HOME/.config/mako"
cp kitty/ "$HOME/.config/kitty"

rm "$HOME/.config/hypr/hyprland.conf"
mv hypr/ "$HOME/.config/hypr"

mv nwg-look/ "$HOME/.config/nwg-look"

cd ..

sudo pacman -S ttf-jetbrains-mono-nerd

git clone https://github.com/vinceliuice/Graphite-gtk-theme.git
cd Graphite-gtk-theme
chmod +x install.sh
./install.sh -c dark -s standard -s compact -l --tweaks black rimless 

cd ..

yay -S bibata-cursor-theme-bin
yay -S papirus-icon-theme
yay -S papirus-folders

papirus-folders -C black

slow_echo "hahahaha this pc is mine now"

install_if_missing zsh
sudo chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
