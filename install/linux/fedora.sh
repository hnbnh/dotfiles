#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

source ./home/.config/bash/functions
source ./install/linux/common.sh

readarray -t coprs < <(strip_list install/linux/fedora.coprs)
readarray -t packages < <(strip_list install/linux/fedora.packages)

for copr in "${coprs[@]}"; do
  sudo dnf copr enable -y "$copr"
done

sudo dnf install -y "${packages[@]}"

sudo chsh -s /bin/zsh "$USER"

use_numtide_cache

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

exec ./home/.local/bin/nix-switch
