#!/usr/bin/env bash
# Print a JSON object of {pname: version} for every package declared in the
# flake's configurations. Evaluation only; nothing is built.
set -euo pipefail

# symlinkJoin wrappers have no pname/version attrs; their drv name carries both.
expr='ps: builtins.listToAttrs (builtins.filter (v: v.value != "") (map (p:
  let d = builtins.parseDrvName p.name; in
  { name = p.pname or d.name; value = p.version or d.version; }) ps))'

for attr in \
  homeConfigurations.hnbnh.config.home.packages \
  darwinConfigurations.hnbnh.config.home-manager.users.hnbnh.home.packages \
  darwinConfigurations.hnbnh.config.environment.systemPackages; do
  nix eval --json ".#${attr}" --apply "$expr"
done | jq -s add
