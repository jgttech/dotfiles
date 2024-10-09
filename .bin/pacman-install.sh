#!/usr/bin/env bash
base=$1
local_dir=".dotfiles"

if [[ "$2" = "local" ]]; then
  base="$HOME/$local_dir"
fi

bin="$base/.bin"
utils="$bin/utils"
install="$bin/install"

source "$utils/colors.sh"
source "$utils/separator.sh"
source "$utils/section.sh"
source "$utils/can_install.sh"

# Begin installation
yay_dir="$HOME/.yay"

section "Installing ZSH"
if can_install "zsh"; then
  sudo pacman -S zsh
  chsh -s $(which zsh)
  zsh --version
fi

section "Installing yay..."
if can_install "yay"; then
  sudo pacman -S --needed git base-devel < /dev/tty
  git clone https://aur.archlinux.org/yay.git $yay_dir
  cd $yay_dir
  makepkg -si
fi

section "Installing homebrew..."

if can_install "brew"; then
  echo ""
  echo -e $(bold $(yellow "WARNING"))
  echo "There may be additional instructions"
  echo "that Homebrew needs to be performed to"
  echo "complete the installation."
  echo ""

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
  brew upgrade
  brew install cffi
fi

section "Installing system packages..."
echo ""

yay -S \
  fswatch \
  python \
  python-pipx \
  ruby \
  perl \
  tree-sitter \
  php \
  rust \
  luarocks \
  odin \
  go \
  < /dev/tty

pipx install black

go install golang.org/x/telemetry/cmd/gotelemetry@latest
go telemetry off
rm -rfv ~/.config/go/telemetry

section "Node Version Manager"
echo ""
echo "This needs to be done manually because the terminal"
echo "session needs to be changed to ZSH. Once changed, ZSH"
echo "needs to be configured and setup. After that run:"
echo ""
echo "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash"
