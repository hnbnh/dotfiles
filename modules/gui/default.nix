{ lib, platform, ... }:

{
  imports =
    lib.optional platform.isDarwin ./darwin.nix
    ++ lib.optional platform.isLinux ./linux.nix;
}
