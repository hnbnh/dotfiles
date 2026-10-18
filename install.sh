#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

if [ "$(pwd -P)" != "$(cd ~ && pwd -P)/dotfiles" ]; then
  echo "Clone this repository to ~/dotfiles; $(pwd -P) cannot be applied" >&2
  exit 1
fi

case "$(uname -s)" in
  Darwin)
    exec ./install/macos.sh
    ;;
  Linux)
    if [ -f /etc/fedora-release ]; then
      exec ./install/linux/fedora.sh
    elif grep -qx 'ID=ubuntu' /etc/os-release; then
      exec ./install/linux/ubuntu.sh
    fi
    echo "Unsupported Linux distribution" >&2
    exit 1
    ;;
  *)
    echo "Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac
