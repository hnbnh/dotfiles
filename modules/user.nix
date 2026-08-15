{ ... }:

{
  imports = [
    ./dotfiles.nix
    ./packages/common.nix
  ];

  home.stateVersion = "26.11";
}
