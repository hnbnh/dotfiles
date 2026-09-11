# nix-darwin on Darwin, system-manager on Linux.
#
# Only macOS has desktop settings here, as nix-darwin options
# (system.defaults). The Linux desktop session is home-manager and lives in
# modules/session.
{ lib, platform, ... }:

{
  imports = lib.optional platform.isDarwin ./darwin.nix;
}
