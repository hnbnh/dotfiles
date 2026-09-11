# system-manager, Fedora only.
#
# The Fedora half of the keyboard story; macOS's is modules/keyboard/darwin.nix.
# The keyd CLI is installed here too, from the daemon's own package.
{ config, lib, nixosModulesPath, ... }:

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

    environment.systemPackages = [ config.services.keyd.package ];

    environment.etc."modules-load.d/keyd.conf".text = ''
      uinput
    '';
  };
}
