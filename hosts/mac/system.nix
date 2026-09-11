# nix-darwin.
{ ... }:

{
  imports = [
    ../../modules/cli/darwin.nix
    ../../modules/desktop/darwin.nix
    ../../modules/gui/darwin.nix
    ../../modules/keyboard/darwin.nix
  ];
}
