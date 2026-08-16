{ pkgs, ... }:

{
  home.packages = with pkgs; [
    calibre # marked broken on aarch64-darwin, so Linux-only
    cliphist
    # hyprpanel was archived in nixpkgs (2026-07); wayle is the suggested successor
    hyprpaper
    hyprsunset
    tofi
    wob
    xremap
  ];
}
