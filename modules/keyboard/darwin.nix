# nix-darwin.
#
# The macOS half of the keyboard story; Fedora's is modules/keyboard/linux.nix.
{ ... }:

{
  homebrew.casks = [
    "karabiner-elements"
  ];
}
