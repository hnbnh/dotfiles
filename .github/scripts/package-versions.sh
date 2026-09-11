#!/usr/bin/env bash
# Print a JSON object of {pname: version} for every package declared in the
# flake's configurations. Evaluation only; nothing is built.
set -euo pipefail

# symlinkJoin wrappers have no pname/version attrs; their drv name carries both.
expr='ps: builtins.listToAttrs (builtins.filter (v: v.value != "") (map (p:
  let d = builtins.parseDrvName p.name; in
  { name = p.pname or d.name; value = p.version or d.version; }) ps))'

# The literal `hnbnh` below is the pure-evaluation fallback from flake.nix; CI
# never passes --impure, so that is the account name in the evaluated config.
# Adding --impure here would export the runner's USER and break this path.
for attr in \
  systemConfigs.fedora.config.environment.systemPackages \
  homeConfigurations.fedora.config.home.packages \
  darwinConfigurations.mac.config.home-manager.users.hnbnh.home.packages \
  darwinConfigurations.mac.config.environment.systemPackages; do
  nix eval --json ".#${attr}" --apply "$expr"
done | jq -s add
