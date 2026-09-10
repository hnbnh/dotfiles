# nix-darwin.
{ lib, pkgs, ... }:

{
  # User-facing CLI tools live in modules/cli/common.nix (home.packages).
  # Only things with system-level daemon or socket expectations belong here.
  # mkOrder 1100 here only affects buildEnv collision resolution inside
  # /run/current-system/sw, not PATH ordering; kept for symmetry with
  # environment.systemPath in modules/macos/homebrew.nix.
  environment.systemPackages = lib.mkOrder 1100 (with pkgs; [
    docker
    gnupg
  ]);

  homebrew.brews = [
    "gemini-cli"
    "libyaml"
    "mole"
    "sqlite3"
  ];
}
