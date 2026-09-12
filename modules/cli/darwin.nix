{ lib, pkgs, ... }:

{
  # mkOrder 1100 here only affects buildEnv collision resolution inside
  # /run/current-system/sw, not PATH ordering; kept for symmetry with
  # environment.systemPath in base/darwin.nix.
  environment.systemPackages = lib.mkOrder 1100 (with pkgs; [
    gnupg
  ]);

  homebrew.brews = [
    "libyaml"
    "mole"
    "sqlite3"
  ];
}
