{ config, lib, platform, username, ... }:

{
  imports = [ ../modules/cli ];

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

  # mkOrder 1100 places Homebrew after the Nix profiles (order 1000) and
  # before nix-darwin's own /usr/local/bin:/usr/bin:... group (mkOrder 1200).
  # 1100 is the only order band between the two, so it's the only way to pin
  # this position without tying at 1000 and leaving the result to
  # module-import order.
  environment.systemPath = lib.mkOrder 1100 [
    "${config.homebrew.prefix}/bin"
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
