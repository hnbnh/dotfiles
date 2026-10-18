#!/bin/bash

# Shared by the Linux installers, which source it from the repo root.

# The package lists are plain text. `#` starts a comment anywhere on a line,
# and blank lines are ignored.
function strip_list {
  sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^[[:space:]]*$/d' "$1"
}

function use_numtide_cache {
  if ! grep -q 'cache.numtide.com' /etc/nix/nix.conf 2>/dev/null; then
    sudo tee -a /etc/nix/nix.conf >/dev/null <<'NIXCONF'
extra-substituters = https://cache.numtide.com
extra-trusted-public-keys = niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=
NIXCONF
    sudo systemctl try-restart nix-daemon
  fi
}
