{ pkgs, ... }:

{
  home.packages = with pkgs; [
    inter # Noctalia's UI font; Fedora does not ship it
  ];

  fonts.fontconfig.enable = true;
}
