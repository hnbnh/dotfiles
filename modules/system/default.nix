{ pkgs, ... }:

{
  imports = [ ./keyd.nix ];

  nixpkgs.hostPlatform = "aarch64-linux";

  system-manager.allowAnyDistro = true;

  system-graphics = {
    enable = true;
    package = pkgs.mesa;
  };

  systemd.maskedUnits = [ "NetworkManager-wait-online.service" ];

  # Fedora's pam_env also reads /etc/environment.d but doesn't expand ${...},
  # so this file leaves sudo sessions with a literal PATH (no /usr/bin) and the
  # next `switch` can't find systemd-tmpfiles. Login shells still get the nix
  # PATH via /etc/profile.d/system-manager-path.sh.
  environment.etc."environment.d/10-system-manager.conf".enable = false;
}
