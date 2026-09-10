# nix-darwin, every Darwin host.
{ platform, username, ... }:

{
  system.primaryUser = username;

  # Must agree with home.homeDirectory in base/home.nix: home-manager's
  # nix-darwin module derives that option from this one, and the two
  # definitions have to be equal for the merge to succeed.
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
    # Only ever applies to regular files and directories: both backup
    # branches in home-manager's check-link-targets.sh are guarded on
    # `! -L`, so a symlink already in the way is not backed up — it aborts
    # activation instead. Old dotfile symlinks were removed explicitly
    # before the first switch. This setting is here for the newly-linked
    # paths (~/.claude/agents and friends), where a real directory may
    # already exist.
    backupFileExtension = "hm-bak";
    extraSpecialArgs = { inherit platform username; };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
