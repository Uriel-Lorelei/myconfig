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

install_if_missing waybar thunar swww nwg-look

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..

git clone https://github.com/Uriel-Lorelei/myconfig.git
cd myconfig

mkdir -p "$HOME/.config/waybar"
mkdir -p "$HOME/.config/mako"
mkdir -p "$HOME/.config/kitty"
mkdir -p "$HOME/.config/hypr"
mkdir -p "$HOME/.config/nwg-look"

cp -r waybar/* "$HOME/.config/waybar"
cp -r mako/* "$HOME/.config/mako"
cp -r kitty/* "$HOME/.config/kitty"
cp -r hypr/* "$HOME/.config/hypr"
cp -r nwg-look/* "$HOME/.config/nwg-look"

cd "$HOME" 

git clone https://github.com/vinceliuice/Graphite-gtk-theme.git
cd Graphite-gtk-theme
./install.sh -c dark -s standard -s compact -l --tweaks black rimless 

cd "$HOME" 

yay -S bibata-cursor-theme

install_if_missing zsh
sudo chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

slow_echo "hahahaha this pc is mine now"
