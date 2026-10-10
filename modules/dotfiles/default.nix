# Places every file in the home tree into $HOME as an out-of-store
# symlink, so edits in the repo take effect immediately without a rebuild.
# Agent skills are also linked into the skill directories of tools that do
# not read ~/.agents/skills.
{ config, lib, ... }:

let
  linkTree = import ./link-tree.nix { inherit lib; };

  tree = "home";
  repo = "${config.home.homeDirectory}/dotfiles";

  submodules =
    let
      gitmodules = ../.. + "/.gitmodules";
      lines = lib.optionals (builtins.pathExists gitmodules) (
        lib.splitString "\n" (builtins.readFile gitmodules)
      );
      pathOf = builtins.match "[[:space:]]*path[[:space:]]*=[[:space:]]*([^[:space:]]+)[[:space:]]*";
    in
    map lib.head (lib.filter (m: m != null) (map pathOf lines));

  paths = linkTree.linkPaths {
    root = ../.. + "/${tree}";
    whole = map (lib.removePrefix "${tree}/") (lib.filter (lib.hasPrefix "${tree}/") submodules);
  };

  skillMirrors = linkTree.mirrorPaths {
    from = ".agents/skills";
    to = [
      ".claude/skills"
      ".gemini/antigravity/skills"
    ];
    inherit paths;
  };

  link = path: {
    source = config.lib.file.mkOutOfStoreSymlink "${repo}/${tree}/${path}";
  };
in
{
  home.file = lib.genAttrs paths link // lib.mapAttrs (_: link) skillMirrors;
}
