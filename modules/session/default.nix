# home-manager, Fedora only.
#
# The Linux desktop session: input method, portals and the Noctalia shell.
# macOS desktop settings are nix-darwin options and live in modules/desktop.
{ lib, platform, ... }:

{
  imports = lib.optional platform.isLinux ./linux;
}
