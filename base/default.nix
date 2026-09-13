{ lib, platform, username, ... }:

{
  imports = [
    ../modules/dotfiles
    ../modules/fonts
    ../modules/plugins
  ];

  home.username = lib.mkDefault username;

  home.homeDirectory = lib.mkDefault (
    if platform.isDarwin then "/Users/${username}" else "/home/${username}"
  );

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.stateVersion = "26.11";
}
