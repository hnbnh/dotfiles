# The Mac: nix-darwin for the machine, home-manager embedded in it.
{
  # nix-darwin.
  system = {
    imports = [
      ../modules/cli/darwin.nix
      ../modules/desktop/darwin.nix
      ../modules/gui/darwin.nix
      ../modules/keyboard/darwin.nix
    ];
  };

  # home-manager. Nothing host-specific yet.
  home = { };
}
