# System layer for Fedora, applied with system-manager. It can only touch
# /etc and systemd units, so package installs and user accounts stay in
# home-manager (modules/linux.nix) or the bootstrap in install/linux/fedora.sh.
{ ... }:

{
  nixpkgs.hostPlatform = "aarch64-linux";

  # Fedora is not on system-manager's tested list; it only skips the
  # /etc/os-release check.
  system-manager.allowAnyDistro = true;

  # Blocks boot for up to 30s waiting for a network that a laptop rarely
  # has yet.
  systemd.maskedUnits = [ "NetworkManager-wait-online.service" ];

  # Don't ship system-manager's /etc/environment.d file. Its PATH/XDG_DATA_DIRS
  # lines reference ${PATH}/${XDG_DATA_DIRS}, which only systemd expands. On
  # Fedora, pam_env *also* reads /etc/environment.d and does NOT expand ${...},
  # so every sudo session gets a literal PATH with no /usr/bin. That makes the
  # privileged system-manager-engine unable to find systemd-tmpfiles on the
  # next `switch`, panicking activation. Login shells still get the nix PATH
  # via /etc/profile.d/system-manager-path.sh, which expands correctly.
  environment.etc."environment.d/10-system-manager.conf".enable = false;
}
