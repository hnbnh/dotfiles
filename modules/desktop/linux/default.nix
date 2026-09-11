# home-manager, Fedora only.
{ ... }:

{
  imports = [
    ./input-method.nix
    ./noctalia.nix
    ./portals.nix
  ];
}
