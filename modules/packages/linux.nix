{ pkgs, ... }:

{
  home.packages = with pkgs; [
    blueman
    calibre # marked broken on aarch64-darwin, so Linux-only
    cliphist
    networkmanagerapplet
    obs-studio
    papirus-icon-theme
    swappy
    tofi
    wob
    xournalpp
    xremap
    zathura
    zsh # login shell; macOS uses the system zsh
  ];
}
