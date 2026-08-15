# Return paths to symlink from a $HOME-mirror tree:
#
#   root/                         [ "bar" "baz/x" "baz/y" "foo" ]
#   ├── foo
#   ├── bar/
#   │   ├── a
#   │   └── b
#   ├── baz/
#   │   ├── .split
#   │   ├── x
#   │   └── y
#   └── .DS_Store
#
# `.split` and `.DS_Store` are ignored. A `.split` makes its directory and
# every ancestor descend, preventing a whole-directory symlink from swallowing
# a tool's state alongside its config.
#
# Limitation: `builtins.readDir` treats symlinked directories as leaves, so a
# `.split` beneath one is ignored. Do not place a `.split` under a symlinked
# directory or symlink a config directory that contains state.
{ lib }:

rec {
  ignored = name: name == ".split" || name == ".DS_Store";

  # True if `dir` itself, or any directory beneath it, contains `.split`.
  hasSplitBelow =
    dir:
    let
      entries = builtins.readDir dir;
    in
    entries ? ".split"
    || lib.any (
      name: entries.${name} == "directory" && hasSplitBelow (dir + "/${name}")
    ) (builtins.attrNames entries);

  linkPaths =
    root:
    let
      walk =
        rel:
        let
          dir = if rel == "" then root else root + "/${rel}";
          entries = lib.filterAttrs (name: _: !ignored name) (builtins.readDir dir);
        in
        lib.concatLists (
          lib.mapAttrsToList (
            name: type:
            let
              sub = if rel == "" then name else "${rel}/${name}";
            in
            if type == "directory" && hasSplitBelow (root + "/${sub}") then
              walk sub
            else
              [ sub ]
          ) entries
        );
    in
    lib.sort lib.lessThan (walk "");
}
