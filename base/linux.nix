# system-manager, every Linux host. Content below is Fedora-specific; a
# non-Fedora Linux host in the registry would inherit it and need a split.
{ pkgs, platform, ... }:

{
  imports = [ ../modules/cli ];

  nixpkgs.hostPlatform = platform.system;

  system-manager.allowAnyDistro = true;

  system-graphics = {
    enable = true;
    package = pkgs.mesa;
  };

  systemd.maskedUnits = [ "NetworkManager-wait-online.service" ];

  # NixOS plumbing with nothing to do on Fedora.
  services.userborn.enable = false; # host owns /etc/passwd; userborn dies on colliding GIDs
  security.enableWrappers = false; # Fedora already ships setuid mount/umount
  # Fedora's pam_env reads this without expanding ${...},
  # so sudo gets a literal PATH (no /usr/bin) and the next `switch` loses systemd-tmpfiles.
  environment.etc."environment.d/10-system-manager.conf".enable = false;
}
