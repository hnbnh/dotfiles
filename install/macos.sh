#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")/.."

source ./modules/home/.config/bash/functions

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

git submodule update --init --recursive

sudo NIX_CONFIG="$NIX_CONFIG" /nix/var/nix/profiles/default/bin/nix run nix-darwin \
  --extra-experimental-features "nix-command flakes" -- switch --flake '.#hnbnh'
