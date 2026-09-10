# home-manager, Fedora only.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    keyd # the keyd CLI; the service is modules/keyboard/linux.nix (system-manager)
    wl-clipboard # nvim's "+ register; Noctalia's clipboard is its own store
    zsh
  ];
}
