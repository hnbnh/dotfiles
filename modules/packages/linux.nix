{ pkgs, ... }:

{
  home.packages = with pkgs; [
    blueman
    calibre # marked broken on aarch64-darwin, so Linux-only
    cliphist
    hyprland
    # hyprpanel was archived in nixpkgs (2026-07); wayle is the suggested successor
    hyprpaper
    hyprsunset
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
