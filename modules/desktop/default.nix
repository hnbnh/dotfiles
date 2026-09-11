# nix-darwin on Darwin, system-manager on Linux.
#
# Only macOS has system-level desktop settings. The Linux desktop session is
# user-level and lives in modules/session (home-manager).
{ lib, platform, ... }:

{
  imports = lib.optional platform.isDarwin ./darwin.nix;
}
