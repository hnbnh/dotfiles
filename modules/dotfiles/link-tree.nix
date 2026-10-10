# Return paths to symlink from a $HOME-mirror tree:
#
#   root/                         [ "bar/a" "bar/b" "foo" "vendor" ]
#   ├── foo
#   ├── bar/
#   │   ├── a
#   │   └── b
#   ├── vendor/                   (listed in `whole`)
#   └── .DS_Store
#
# Every file gets its own symlink, so each directory in $HOME stays a real
# directory and a tool writing state next to its config cannot reach the repo.
#
# `whole` names directories to link in one piece instead. They are contributed
# unconditionally and never descended into, because the caller passes the
# git-filtered store copy: a submodule is empty there, or missing outright, yet
# the working tree the symlink points at is populated.
#
# `mirrorPaths` re-roots every path under `from` beneath each directory in
# `to`, mapping target to original, so one repo file can be linked into
# several tools' directories:
#
#   mirrorPaths {                 { ".claude/skills/x/SKILL.md"
#     from = ".agents/skills";        = ".agents/skills/x/SKILL.md"; }
#     to = [ ".claude/skills" ];
#     paths = [ ".agents/skills/x/SKILL.md" "foo" ];
#   }
{ lib }:

let
  ignored = name: name == ".DS_Store";

  scan =
    whole: rel: dir:
    lib.concatLists (
      lib.mapAttrsToList (
        name: type:
        let
          sub = if rel == "" then name else "${rel}/${name}";
        in
        if type == "directory" && !(builtins.elem sub whole) then
          scan whole sub (dir + "/${name}")
        else
          [ sub ]
      ) (lib.filterAttrs (name: _: !ignored name) (builtins.readDir dir))
    );
in
{
  linkPaths =
    {
      root,
      whole ? [ ],
    }:
    lib.sort lib.lessThan (lib.unique (scan whole "" root ++ whole));

  mirrorPaths =
    {
      from,
      to,
      paths,
    }:
    let
      prefix = "${from}/";
      under = lib.filter (lib.hasPrefix prefix) paths;
    in
    lib.listToAttrs (
      lib.concatMap (
        dir: map (path: lib.nameValuePair "${dir}/${lib.removePrefix prefix path}" path) under
      ) to
    );
}
