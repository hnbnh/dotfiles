# nix-darwin.
{ ... }:

{
  imports = [
    ../../modules/cli/darwin.nix
    ../../modules/gui/darwin.nix
    ../../modules/keyboard/darwin.nix
    ../../modules/macos/defaults.nix
    ../../modules/macos/homebrew.nix
  ];
}
