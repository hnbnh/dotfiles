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
# A `.split` file makes its directory and every ancestor descend, so a
# whole-directory symlink cannot swallow a tool's state alongside its config.
# Descending drops `.split` and `.DS_Store`; a whole-directory link carries them.
#
# Empty directories are skipped — git cannot reproduce them on a fresh clone.
#
# Footgun: under a flake the caller passes the git-filtered store copy, which
# omits submodules, so a `.split` at or above a submodule drops it from the
# result while the emitted symlinks still point at the working tree.
{ lib }:

let
  ignored = name: name == ".split" || name == ".DS_Store";

  # `readDir` calls a symlink "symlink" whatever it resolves to, and reading a
  # non-directory is an uncatchable eval error, so probe for the marker instead.
  # Cost: a `.split` nested deeper under a symlinked directory goes unseen.
  isDir =
    path: type: type == "directory" || (type == "symlink" && builtins.pathExists (path + "/.split"));

  # One `readDir` per directory. `paths` is forced only where the walk descends,
  # so the subtrees behind whole-directory links are never built.
  scan =
    rel: dir:
    let
      raw = builtins.readDir dir;
      entries = lib.filterAttrs (name: _: !ignored name) raw;

      children = lib.mapAttrsToList (
        name: type:
        let
          sub = if rel == "" then name else "${rel}/${name}";
          path = dir + "/${name}";
        in
        if isDir path type then
          let
            inner = scan sub path;
          in
          {
            inherit (inner) split;
            paths = if inner.split then inner.paths else lib.optional inner.linkable sub;
          }
        else
          {
            split = false;
            paths = [ sub ];
          }
      ) entries;
    in
    {
      split = (raw.".split" or null) == "regular" || lib.any (c: c.split) children;
      paths = lib.concatMap (c: c.paths) children;
      linkable = entries != { };
    };
in
{
  linkPaths = root: lib.sort lib.lessThan (scan "" root).paths;
}
