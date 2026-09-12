{ lib, platform, ... }:

{
  imports = lib.optional platform.isDarwin ./darwin.nix;
}
