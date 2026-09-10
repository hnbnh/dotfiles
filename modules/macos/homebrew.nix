# nix-darwin.
#
# The Homebrew mechanism only: enable, taps and PATH placement. Package lists
# live with their topics — modules/cli/darwin.nix, modules/gui/darwin.nix and
# modules/keyboard/darwin.nix each contribute to homebrew.brews/casks, which
# are list-typed and concatenate.
{ config, lib, ... }:

{
  homebrew = {
    enable = true;
    taps = [
    ];
  };

  # mkOrder 1100 places Homebrew after the Nix profiles (order 1000) and
  # before nix-darwin's own /usr/local/bin:/usr/bin:... group (mkOrder 1200).
  # 1100 is the only order band between the two, so it's the only way to pin
  # this position without tying at 1000 and leaving the result to
  # module-import order.
  environment.systemPath = lib.mkOrder 1100 [
    "${config.homebrew.prefix}/bin"
  ];
}
