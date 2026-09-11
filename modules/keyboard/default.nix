# nix-darwin on Darwin, system-manager on Linux.
{ lib, platform, ... }:

{
  imports =
    lib.optional platform.isDarwin ./darwin.nix
    ++ lib.optional platform.isLinux ./linux.nix;
}
