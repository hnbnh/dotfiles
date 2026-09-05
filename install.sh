#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

case "$(uname -s)" in
  Darwin)
    exec ./install/macos.sh
    ;;
  Linux)
    if [ ! -f /etc/fedora-release ]; then
      echo "Unsupported Linux distribution" >&2
      exit 1
    fi
    exec ./install/linux/fedora.sh
    ;;
  *)
    echo "Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac
