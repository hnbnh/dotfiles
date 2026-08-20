#!/bin/bash

set -e

source ./modules/home/.config/bash/functions

function setup_linux {
  sudo dnf install -y nix zsh util-linux-user
  sudo systemctl enable --now nix-daemon

  sudo dnf copr enable -y avengemedia/dms
  sudo dnf install -y niri dms
  systemctl --user add-wants niri.service dms

  git submodule update --init --recursive

  local nix_flags=(--extra-experimental-features "nix-command flakes")

  # System layer: /etc and systemd units.
  nix run "${nix_flags[@]}" github:numtide/system-manager -- switch --flake . --sudo

  # User layer: packages and dotfiles; the compositor is an RPM now.
  nix run "${nix_flags[@]}" home-manager -- switch --flake '.#hnbnh'

  # What neither manager can express on a non-NixOS host. All idempotent.
  #
  # Login shell.
  sudo chsh -s /bin/zsh "$USER"
}

function setup_macos {
  sudo whoami

  # Install nix
  if ! have "nix-build"; then
    curl -L https://nixos.org/nix/install | sh
    # Workaround for https://github.com/LnL7/nix-darwin/issues/149
    sudo rm /etc/nix/nix.conf
  fi

  # Install homebrew
  if ! have brew; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o /tmp/brew-install.sh
    NONINTERACTIVE=1 sudo -u "$(id -un)" bash /tmp/brew-install.sh
  fi

  # Submodules provide zsh plugins and friends; without them the switch
  # succeeds but zsh errors on every start.
  git submodule update --init --recursive

  # Set up nix-darwin + home-manager; this also places every dotfile
  /nix/var/nix/profiles/default/bin/nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake '.#hnbnh'
}

function main() {
  if [ "$(uname)" == "Darwin" ]; then
    setup_macos
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    setup_linux
  else
    echo "Unsupported OS"
    exit 1
  fi
}

main
