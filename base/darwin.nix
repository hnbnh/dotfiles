# nix-darwin, every Darwin host.
{ config, lib, platform, username, ... }:

{
  system.primaryUser = username;

  # Must agree with home.homeDirectory in base/default.nix: home-manager's
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
  };

  # The Homebrew mechanism only: enable, taps and PATH placement. Package lists
  # live with their topics — modules/cli/darwin.nix, modules/gui/darwin.nix and
  # modules/keyboard/darwin.nix each contribute to homebrew.brews/casks, which
  # are list-typed and concatenate.
  #
  # Enabled here rather than in a topic because nix-darwin only runs the
  # Brewfile when homebrew.enable is set, so a host that skipped it would
  # silently install none of those lists.
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
