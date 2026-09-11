# The Mac: nix-darwin for the machine, home-manager embedded in it.
{
  # nix-darwin.
  system = {
    imports = [
      ../modules/desktop
      ../modules/gui
      ../modules/keyboard
    ];
  };

  # home-manager. Nothing host-specific yet.
  home = { };
}
