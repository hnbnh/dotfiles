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

sudo systemctl enable --now nix-daemon
systemctl --user add-wants niri.service dms

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

nix run "${nix_flags[@]}" github:numtide/system-manager -- switch --flake . --sudo
nix run "${nix_flags[@]}" home-manager -- switch --flake '.#hnbnh'

# DankMaterialShell theme. Catppuccin is an official registry theme; the shell's
# Theme Browser installs it by cloning the registry, so do the same here for a
# reproducible first boot. settings.json stays GUI-owned and untracked, so this
# merges rather than overwrites and is safe to re-run.
dms_config="$HOME/.config/DankMaterialShell"
theme_dir="$dms_config/themes/catppuccin"

if [ ! -d "$theme_dir" ]; then
  tmp=$(mktemp -d)
  git clone --depth 1 --filter=blob:none --sparse \
    https://github.com/AvengeMedia/dms-plugin-registry.git "$tmp"
  git -C "$tmp" sparse-checkout set themes/catppuccin
  mkdir -p "$theme_dir"
  cp -R "$tmp/themes/catppuccin/." "$theme_dir/"
  rm -rf "$tmp"
fi

mkdir -p "$dms_config"
settings="$dms_config/settings.json"
[ -f "$settings" ] || echo '{}' > "$settings"

# JSON does no tilde expansion, so customThemeFile must be absolute.
theme_seed=$(jq -n --arg file "$theme_dir/theme.json" '{
  currentThemeName: "custom",
  currentThemeCategory: "registry",
  customThemeFile: $file,
  registryThemeVariants: {
    catppuccin: { dark: { flavor: "macchiato", accent: "green" } }
  }
}')

jq -s '.[0] * .[1]' "$settings" <(printf '%s' "$theme_seed") > "$settings.tmp"
mv "$settings.tmp" "$settings"

sudo chsh -s /bin/zsh "$USER"
