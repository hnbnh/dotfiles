#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

source ./home/.config/bash/functions
source ./install/linux/common.sh

readarray -t packages < <(strip_list install/linux/ubuntu.packages)

sudo apt-get update
sudo apt-get install -y "${packages[@]}"

sudo chsh -s /bin/zsh "$USER"

export PATH="/nix/var/nix/profiles/default/bin:$PATH"

# Install nix
if ! have nix; then
  nix_install="$(mktemp)"
  curl -fsSL https://nixos.org/nix/install -o "$nix_install"
  sh "$nix_install" --daemon --yes
  rm -f "$nix_install"
fi

use_numtide_cache

exec ./home/.local/bin/nix-switch
