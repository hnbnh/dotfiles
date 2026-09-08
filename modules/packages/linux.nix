{ pkgs, ... }:

{
  home.packages = with pkgs; [
    calibre # marked broken on aarch64-darwin, so Linux-only
    ghostty
    inter # Noctalia's UI font; Fedora does not ship it
    keyd
    kitty
    obs-studio
    papirus-icon-theme
    rofi
    satty # annotates what niri's built-in screenshot captures
    wl-clipboard # nvim's "+ register; Noctalia's clipboard is its own store
    xournalpp
    zathura
    zsh
  ];
}
