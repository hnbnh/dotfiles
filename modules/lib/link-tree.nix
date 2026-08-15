# Walks a $HOME-mirror tree and returns the set of paths to symlink.
#
# A directory is linked as a whole unless it (or something beneath it)
# contains a `.split` marker file, in which case the walk descends into it
# and links its contents individually. `.split` marks directories whose tool
# writes state, logs, sockets, or credentials alongside its config, where a
# whole-directory link would put that state in the repo.
#
# The marker's effect must propagate upward: an ancestor of a `.split`
# directory can't be linked whole either, or the single symlink at that
# ancestor would swallow the split-out subtree right back into the repo,
# defeating the marker. So the whole-vs-descend decision for a directory
# checks its entire subtree for `.split`, not just its own immediate
# entries — this is what lets `.gemini/antigravity/.split` force a descent
# through both `.gemini` and `.gemini/antigravity`.
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
