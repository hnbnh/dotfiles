# system-manager, Fedora only.
#
# The Fedora half of the keyboard story; macOS's is modules/keyboard/darwin.nix.
# The keyd CLI package lives in modules/cli/linux.nix (home-manager); this file is the service.
{ lib, nixosModulesPath, ... }:

{
  imports = [ (nixosModulesPath + "/services/hardware/keyd.nix") ];

  options.hardware.uinput.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = {
    services.keyd = {
      enable = true;

      keyboards.default.settings = {
        global.overload_tap_timeout = 200;

        main = {
          # Caps Lock: Ctrl when held, Esc when tapped.
          capslock = "overload(control, esc)";

          # Swap meta and alt; macro() emits actual modifier keypresses for the shell.
          leftmeta = "layer(alt)";
          leftalt = "overload(meta, macro(leftmeta))";
          rightalt = "overload(meta, macro(rightmeta))";
        };
      };
    };

    systemd.services.keyd.serviceConfig.SupplementaryGroups = lib.mkForce [ ];

    environment.etc."modules-load.d/keyd.conf".text = ''
      uinput
    '';
  };
}
