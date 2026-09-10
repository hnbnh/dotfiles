# home-manager, Fedora only.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    calibre # marked broken on aarch64-darwin, so Linux-only
    ghostty
    kitty
    obs-studio
    papirus-icon-theme
    rofi
    satty # annotates what niri's built-in screenshot captures
    xournalpp
    zathura
  ];
}
