{ lib, platform, ... }:

{
  imports = lib.optional platform.isLinux ./linux;
}
