{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wl-clipboard # nvim's "+ register; Noctalia's clipboard is its own store
    zsh
  ];
}
