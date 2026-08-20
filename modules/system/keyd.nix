# system-manager whitelists only a few upstream NixOS modules, so services.keyd
# is unreachable. This is that module minus its NixOS-only parts: hardware.uinput
# and a SupplementaryGroups reference to a uinput group Fedora lacks.
{ config, lib, pkgs, ... }:

{
  environment.etc."keyd/default.conf".text = ''
    [ids]
    *

    [global]
    overload_tap_timeout = 200

    [main]
    # Caps Lock: Ctrl when held, Esc when tapped.
    capslock = overload(control, esc)

    # Swap meta and alt.
    leftmeta = layer(alt)
    leftalt = overload(meta, leftmeta)
    rightalt = overload(meta, rightmeta)
  '';

  environment.etc."modules-load.d/keyd.conf".text = ''
    uinput
  '';

  systemd.services.keyd = {
    description = "Keyd remapping daemon";
    documentation = [ "man:keyd(1)" ];
    wantedBy = [ "multi-user.target" ];

    restartTriggers = [ config.environment.etc."keyd/default.conf".source ];

    serviceConfig = {
      ExecStart = lib.getExe pkgs.keyd;
      Restart = "always";

      RuntimeDirectory = "keyd";

      CapabilityBoundingSet = [
        "CAP_SYS_NICE"
        "CAP_IPC_LOCK"
      ];
      DeviceAllow = [
        "char-input rw"
        "/dev/uinput rw"
      ];
      ProtectClock = true;
      PrivateNetwork = true;
      ProtectHome = true;
      ProtectHostname = true;
      PrivateUsers = false;
      PrivateMounts = true;
      PrivateTmp = true;
      RestrictNamespaces = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectControlGroups = true;
      MemoryDenyWriteExecute = true;
      LockPersonality = true;
      ProtectProc = "invisible";
      SystemCallFilter = [
        "nice"
        "@system-service"
        "~@privileged"
      ];
      RestrictAddressFamilies = [ "AF_UNIX" ];
      RestrictSUIDSGID = true;
      IPAddressDeny = [ "any" ];
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProcSubset = "pid";
      UMask = "0077";
    };
  };
}
