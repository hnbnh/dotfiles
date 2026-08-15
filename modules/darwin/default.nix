{ config, lib, pkgs, ... }:

{
  imports = [
    ./system-defaults.nix
    ./homebrew.nix
    ./fonts.nix
  ];

  # User-facing CLI tools live in modules/packages/common.nix (home.packages).
  # Only things with system-level daemon or socket expectations belong here.
  # Keep the mkOrder 1100 wrapper from Task 1: it pins these after nix-darwin's
  # own contributions rather than letting import depth decide the tie.
  environment.systemPackages = lib.mkOrder 1100 (with pkgs; [
    docker
    gnupg
  ]);

  # mkOrder 1100 places Homebrew after the Nix profiles (order 1000) and
  # before nix-darwin's own /usr/local/bin:/usr/bin:... group (mkOrder 1200),
  # which is where an unwrapped definition happened to land in the old flat
  # configuration.nix. Unwrapped, this ties at order 1000 with nix-darwin's
  # profile paths and the winner depends on import-graph depth — under this
  # module layout that tie flips and Homebrew shadows Nix system-wide.
  environment.systemPath = lib.mkOrder 1100 [
    config.homebrew.prefix
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
