{ platform, username, ... }:

{
  imports = [
    ../modules/dotfiles
    ../modules/fonts
  ];

  home.username = username;

  home.homeDirectory = if platform.isDarwin then "/Users/${username}" else "/home/${username}";

  home.stateVersion = "26.11";
}
