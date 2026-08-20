# System layer for Fedora, applied with system-manager. It can only touch
# /etc and systemd units, so package installs and user accounts stay in
# home-manager (modules/linux.nix) or the bootstrap in install.sh.
{ ... }:

{
  nixpkgs.hostPlatform = "aarch64-linux";

  # Fedora is not on system-manager's tested list; it only skips the
  # /etc/os-release check.
  system-manager.allowAnyDistro = true;

  # Blocks boot for up to 30s waiting for a network that a laptop rarely
  # has yet.
  systemd.maskedUnits = [ "NetworkManager-wait-online.service" ];
}
