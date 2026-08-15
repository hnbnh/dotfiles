{ config, lib, pkgs, ... }:

{
  imports = [
    ./system-defaults.nix
    ./homebrew.nix
    ./fonts.nix
  ];

  # User-facing CLI tools live in modules/packages/common.nix (home.packages).
  # Only things with system-level daemon or socket expectations belong here.
  # mkOrder 1100 here only affects buildEnv collision resolution inside
  # /run/current-system/sw, not PATH ordering; kept for symmetry with
  # environment.systemPath below.
  environment.systemPackages = lib.mkOrder 1100 (with pkgs; [
    docker
    gnupg
  ]);

  # mkOrder 1100 places Homebrew after the Nix profiles (order 1000) and
  # before nix-darwin's own /usr/local/bin:/usr/bin:... group (mkOrder 1200).
  # 1100 is the only order band between the two, so it's the only way to pin
  # this position without tying at 1000 and leaving the result to
  # module-import order.
  environment.systemPath = lib.mkOrder 1100 [
    "${config.homebrew.prefix}/bin"
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
