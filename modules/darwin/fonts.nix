{ pkgs, ... }:

{
  fonts = {
    packages = [
      pkgs.nerd-fonts.meslo-lg
      pkgs.nerd-fonts.geist-mono
    ];
  };
}
