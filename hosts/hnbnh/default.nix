{ ... }:

{
  imports = [
    ../../modules/darwin
  ];

  system.primaryUser = "hnbnh";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
