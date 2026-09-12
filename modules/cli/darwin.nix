{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnupg
    mole-cleaner
  ];
}
