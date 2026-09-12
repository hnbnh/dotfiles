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
  brew_install="$(mktemp)"
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$brew_install"
  NONINTERACTIVE=1 sudo -u "$(id -un)" bash "$brew_install"
  rm -f "$brew_install"
fi

export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$PATH"

exec ./modules/home/.local/bin/switch
