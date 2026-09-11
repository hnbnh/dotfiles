# home-manager, both platforms.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.geist-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
  ];
}
