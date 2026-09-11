# system-manager, every Linux host. Content below is Fedora-specific; a
# non-Fedora Linux host in the registry would inherit it and need a split.
{ nixosModulesPath, pkgs, platform, ... }:

{
  imports = [
    ../modules/cli
    # Builds the MIME and desktop-file caches in /run/system-manager/sw, as
    # home-manager's profile did before the packages moved here.
    (nixosModulesPath + "/config/xdg/mime.nix")
  ];

  nixpkgs.hostPlatform = platform.system;

  system-manager.allowAnyDistro = true;

  # home-manager's profile linked man outputs; keep that for the packages
  # that moved here.
  environment.extraOutputsToInstall = [ "man" ];

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
