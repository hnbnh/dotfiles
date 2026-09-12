{ config, lib, platform, username, ... }:

{
  imports = [
    ../modules/cli
    ../modules/toolchain
  ];

  system.primaryUser = username;

  users.users.${username}.home = "/Users/${username}";

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-bak";
  };

  homebrew = {
    enable = true;
    taps = [
    ];
  };

  # Homebrew and the Nix profiles both ship git, gh, sqlite3. 1100 sits between
  # the Nix profiles (1000) and /usr/bin (1200), so Nix wins without relying on
  # how the module system breaks a 1000-way tie.
  environment.systemPath = lib.mkOrder 1100 [
    "${config.homebrew.prefix}/bin"
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
