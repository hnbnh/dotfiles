# nix-darwin.
{ ... }:

{
  imports = [
    ../../modules/cli/darwin.nix
    ../../modules/gui/darwin.nix
    ../../modules/keyboard/darwin.nix
    ../../modules/macos/defaults.nix
    ../../modules/macos/homebrew.nix
  ];

  system.primaryUser = "hnbnh";

  users.users.hnbnh.home = "/Users/hnbnh";

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
    # Only ever applies to regular files and directories: both backup
    # branches in home-manager's check-link-targets.sh are guarded on
    # `! -L`, so a symlink already in the way is not backed up — it aborts
    # activation instead. Old dotfile symlinks were removed explicitly
    # before the first switch. This setting is here for the newly-linked
    # paths (~/.claude/agents and friends), where a real directory may
    # already exist.
    backupFileExtension = "hm-bak";
    users.hnbnh = import ./home.nix;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
