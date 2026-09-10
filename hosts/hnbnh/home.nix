# home-manager, both platforms.
{ ... }:

{
  imports = [
    ../../modules/cli/common.nix
    ../../modules/dotfiles
    ../../modules/fonts/common.nix
  ];

  home.stateVersion = "26.11";
}
