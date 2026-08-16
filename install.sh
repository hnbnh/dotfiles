#!/bin/bash

set -e

source ./modules/home/.config/bash/functions

function setup_linux {
  # Bootstrap: nix itself and the login stack come from Fedora's repos.
  # greetd/tuigreet stay RPMs on purpose (see modules/system/greetd.nix);
  # everything else is nix.
  sudo dnf install -y nix greetd tuigreet
  sudo systemctl enable --now nix-daemon

  # Submodules provide zsh plugins and friends; without them the switch
  # succeeds but zsh errors on every start.
  git submodule update --init --recursive

  local nix_flags=(--extra-experimental-features "nix-command flakes")

  # System layer: /etc and systemd units.
  nix run "${nix_flags[@]}" github:numtide/system-manager -- switch --flake . --sudo

  # User layer: packages, dotfiles, Hyprland.
  nix run "${nix_flags[@]}" home-manager -- switch --flake '.#hnbnh'

  # What neither manager can express on a non-NixOS host. All idempotent.
  #
  # Login shell. usermod as root skips the /etc/shells check that chsh does.
  sudo usermod -s "$HOME/.nix-profile/bin/zsh" "$USER"
  # GPU drivers for nix-built Wayland programs (targets.genericLinux.gpu);
  # re-run when a later home-manager switch says so.
  sudo "$HOME/.nix-profile/bin/non-nixos-gpu-setup"
  # Swap the display manager for greetd. Takes effect on next boot, so this
  # is safe to run from inside the current session.
  sudo systemctl disable display-manager.service 2>/dev/null || true
  sudo systemctl enable greetd.service
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
