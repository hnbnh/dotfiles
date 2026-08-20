#!/bin/bash

set -e

# Repo root: the flake references and the package lists below are relative.
cd "$(dirname "${BASH_SOURCE[0]}")/../.."

# The package lists are plain text. `#` starts a comment anywhere on a line,
# and blank lines are ignored.
function strip_list {
  sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^[[:space:]]*$/d' "$1"
}

readarray -t coprs < <(strip_list install/linux/fedora.coprs)
readarray -t packages < <(strip_list install/linux/fedora.packages)

# Coprs first; some of the packages below only exist in them.
for copr in "${coprs[@]}"; do
  sudo dnf copr enable -y "$copr"
done

sudo dnf install -y "${packages[@]}"

sudo systemctl enable --now nix-daemon
systemctl --user add-wants niri.service dms

git submodule update --init --recursive

nix_flags=(--extra-experimental-features "nix-command flakes")

# System layer: /etc and systemd units.
nix run "${nix_flags[@]}" github:numtide/system-manager -- switch --flake . --sudo

# User layer: packages and dotfiles; the compositor is an RPM now.
nix run "${nix_flags[@]}" home-manager -- switch --flake '.#hnbnh'

# What neither manager can express on a non-NixOS host. All idempotent.
#
# Login shell.
sudo chsh -s /bin/zsh "$USER"
