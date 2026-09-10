#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

source ./modules/home/.config/bash/functions

# The package lists are plain text. `#` starts a comment anywhere on a line,
# and blank lines are ignored.
function strip_list {
  sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^[[:space:]]*$/d' "$1"
}

readarray -t coprs < <(strip_list install/linux/fedora.coprs)
readarray -t packages < <(strip_list install/linux/fedora.packages)

for copr in "${coprs[@]}"; do
  sudo dnf copr enable -y "$copr"
done

sudo dnf install -y "${packages[@]}"

if ! grep -q 'cache.numtide.com' /etc/nix/nix.conf 2>/dev/null; then
  sudo tee -a /etc/nix/nix.conf >/dev/null <<'NIXCONF'
extra-substituters = https://cache.numtide.com
extra-trusted-public-keys = niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=
NIXCONF
  sudo systemctl try-restart nix-daemon
fi

sudo systemctl enable --now nix-daemon

# Hacky workaround: Fedora has no SELinux context for /nix, so store paths get
# default_t, which systemd won't load units from or exec (203/EXEC; the denial
# is dontaudit'd, so only `semodule -DB` shows it). Relabel the store bin_t
# like /usr/bin; new paths inherit it, so once before the first build suffices.
#
# https://github.com/numtide/system-manager/issues/115
if have selinuxenabled && selinuxenabled; then
  sudo semanage fcontext -a -t bin_t '/nix/store(/.*)?' 2>/dev/null ||
    sudo semanage fcontext -m -t bin_t '/nix/store(/.*)?'
  sudo restorecon -R /nix/store
fi

git submodule update --init --recursive

nix_flags=(--extra-experimental-features "nix-command flakes")

nix run "${nix_flags[@]}" .#system-manager -- switch --flake . --sudo
nix run "${nix_flags[@]}" .#home-manager -- switch --flake '.#hnbnh'

sudo chsh -s /bin/zsh "$USER"
