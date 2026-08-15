#!/bin/bash

set -e

source ./modules/home/.config/bash/functions

function setup_linux {
  # Install ansible & plugins
  have ansible || sudo dnf install ansible -y

  [ -d ~/.ansible/collections/ansible_collections/community ] ||
    ansible-galaxy collection install community.general

  # Run Ansible
  ansible-playbook -i ./ansible/hosts ./ansible/linux.yml --ask-become-pass
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
