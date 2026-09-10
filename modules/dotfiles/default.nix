# home-manager, both platforms.
#
# Places every file in the home tree into $HOME as an out-of-store symlink, so
# edits in the repo take effect immediately without a rebuild.
{ config, lib, ... }:

let
  linkTree = import ./link-tree.nix { inherit lib; };

  tree = "home";
  repo = "${config.home.homeDirectory}/dotfiles";

  paths = linkTree.linkPaths (../.. + "/${tree}");
in
{
  home.file = lib.genAttrs paths (path: {
    source = config.lib.file.mkOutOfStoreSymlink "${repo}/${tree}/${path}";
  });
}
