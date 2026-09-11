# home-manager, every host, both platforms.
{ platform, username, ... }:

{
  imports = [
    ../modules/cli
    ../modules/dotfiles
    ../modules/fonts
  ];

  home.username = username;

  # Must agree with users.users.<name>.home in base/darwin.nix, where
  # home-manager's nix-darwin module also defines this option.
  home.homeDirectory = if platform.isDarwin then "/Users/${username}" else "/home/${username}";

  home.stateVersion = "26.11";
}
