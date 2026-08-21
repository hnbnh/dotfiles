{ pkgs, ... }:

{
  home.packages = with pkgs; [
    calibre # marked broken on aarch64-darwin, so Linux-only
    ghostty
    keyd
    obs-studio
    satty # annotates what niri's built-in screenshot captures
    wl-clipboard # nvim's "+ register; DMS's clipboard is its own store
    xournalpp
    zathura
    zsh # login shell; macOS uses the system zsh
  ];
}
