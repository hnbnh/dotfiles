{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    coreutils-prefixed
    (runCommand "timeout" { } ''
      mkdir -p $out/bin
      ln -s ${coreutils-prefixed}/bin/gtimeout $out/bin/timeout
    '')
    gnupg
    mole-cleaner
  ];
}
