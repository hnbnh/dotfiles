#!/usr/bin/env bats

load helpers

setup() { setup_fixture; }
teardown() { teardown_fixture; }

@test "runs against an empty config and reports nothing to do" {
  run "$RELINK"
  [ "$status" -eq 0 ]
}

@test "plain directory gets one directory link under ~/.config" {
  track config/nvim/init.lua
  run "$RELINK" --apply
  [ "$status" -eq 0 ]
  assert_link "$HOME/.config/nvim" "$DOTFILES_DIR/config/nvim"
}

@test "dotted directory maps to \$HOME, not ~/.config" {
  track config/.claude/CLAUDE.md
  run "$RELINK" --apply
  [ "$status" -eq 0 ]
  assert_link "$HOME/.claude" "$DOTFILES_DIR/config/.claude"
}

@test "dry run changes nothing and exits 1" {
  track config/nvim/init.lua
  run "$RELINK"
  [ "$status" -eq 1 ]
  [ ! -e "$HOME/.config/nvim" ]
}

@test "second apply is a no-op and exits 0" {
  track config/nvim/init.lua
  "$RELINK" --apply
  run "$RELINK" --apply
  [ "$status" -eq 0 ]
}

@test "unknown flag exits 2" {
  run "$RELINK" --nope
  [ "$status" -eq 2 ]
}

@test "symlink pointing outside repo is drift, exits 1, unchanged by --apply" {
  track config/nvim/init.lua
  mkdir -p "$HOME/.config"
  ln -sfn /tmp "$HOME/.config/nvim"
  run "$RELINK" --apply
  [ "$status" -eq 1 ]
  assert_link "$HOME/.config/nvim" "/tmp"
}

@test "symlink pointing outside repo is fixed by --apply --force" {
  track config/nvim/init.lua
  mkdir -p "$HOME/.config"
  ln -sfn /tmp "$HOME/.config/nvim"
  run "$RELINK" --apply --force
  [ "$status" -eq 0 ]
  assert_link "$HOME/.config/nvim" "$DOTFILES_DIR/config/nvim"
}

@test "symlink pointing to repo prefix-neighbor is drift, not silently fixed" {
  track config/nvim/init.lua
  mkdir -p "$HOME/.config" "${DOTFILES_DIR}-evil/config/nvim"
  touch "${DOTFILES_DIR}-evil/config/nvim/init.lua"
  ln -sfn "${DOTFILES_DIR}-evil/config/nvim" "$HOME/.config/nvim"
  run "$RELINK" --apply
  [ "$status" -eq 1 ]
  assert_link "$HOME/.config/nvim" "${DOTFILES_DIR}-evil/config/nvim"
}

@test "symlink pointing inside repo but wrong path is silently fixed by --apply" {
  track config/nvim/init.lua
  track config/old-nvim/init.lua
  mkdir -p "$HOME/.config"
  ln -sfn "$DOTFILES_DIR/config/old-nvim" "$HOME/.config/nvim"
  run "$RELINK" --apply
  [ "$status" -eq 0 ]
  assert_link "$HOME/.config/nvim" "$DOTFILES_DIR/config/nvim"
}

@test "shared directory links each tracked file, not the directory" {
  track config/.claude/CLAUDE.md
  track config/.claude/agents/reviewer.md
  conf <<'EOF'
shared  .claude
EOF
  run "$RELINK" --apply
  [ "$status" -eq 0 ]
  [ ! -L "$HOME/.claude" ]
  [ -d "$HOME/.claude" ]
  [ -d "$HOME/.claude/agents" ]
  [ ! -L "$HOME/.claude/agents" ]
  assert_link "$HOME/.claude/CLAUDE.md" "$DOTFILES_DIR/config/.claude/CLAUDE.md"
  assert_link "$HOME/.claude/agents/reviewer.md" "$DOTFILES_DIR/config/.claude/agents/reviewer.md"
}

@test "untracked files in a shared repo directory are not linked" {
  track config/.claude/CLAUDE.md
  printf 'state\n' > "$DOTFILES_DIR/config/.claude/history.jsonl"
  conf <<'EOF'
shared  .claude
EOF
  "$RELINK" --apply
  [ ! -e "$HOME/.claude/history.jsonl" ]
}

@test "shared plain directory maps under ~/.config" {
  track config/lazygit/config.yml
  conf <<'EOF'
shared  lazygit
EOF
  "$RELINK" --apply
  [ -d "$HOME/.config/lazygit" ]
  assert_link "$HOME/.config/lazygit/config.yml" "$DOTFILES_DIR/config/lazygit/config.yml"
}

@test "unknown directive in links.conf exits 2" {
  conf <<'EOF'
wat  .claude
EOF
  run "$RELINK"
  [ "$status" -eq 2 ]
}

# A typo'd shared name (e.g. ".claud" instead of ".claude") has no matching
# directory under config/, so the real ".claude" directory falls through to
# whole-directory-link treatment instead of per-file links — the exact
# condition that makes a real, state-holding directory look like drift.
# It must not fail silently; warn rather than exit 2, since a shared name
# for a directory that doesn't exist yet on a fresh machine is legitimate.
@test "an unknown shared name produces a warning" {
  track config/.claude/CLAUDE.md
  conf <<'EOF'
shared  .claud
EOF
  run "$RELINK"
  [[ "$output" == *"warn"*".claud"* ]]
}

@test "comments and blank lines in links.conf are ignored" {
  track config/.claude/CLAUDE.md
  conf <<'EOF'
# a comment

shared  .claude
EOF
  run "$RELINK" --apply
  [ "$status" -eq 0 ]
  assert_link "$HOME/.claude/CLAUDE.md" "$DOTFILES_DIR/config/.claude/CLAUDE.md"
}

@test "shared directory whose destination root is a repo symlink migrates instead of drifting" {
  track config/.claude/CLAUDE.md
  "$RELINK" --apply
  conf <<'EOF'
shared  .claude
EOF
  run "$RELINK" --apply
  [ "$status" -eq 0 ]
  [ ! -L "$HOME/.claude" ]
  [ -d "$HOME/.claude" ]
  assert_link "$HOME/.claude/CLAUDE.md" "$DOTFILES_DIR/config/.claude/CLAUDE.md"
  [ -f "$DOTFILES_DIR/config/.claude/CLAUDE.md" ]
  [ ! -L "$DOTFILES_DIR/config/.claude/CLAUDE.md" ]
  [ "$(cat "$DOTFILES_DIR/config/.claude/CLAUDE.md")" = "x" ]
}

@test "shared directory whose destination root is a repo symlink migrates instead of drifting under --apply --force" {
  track config/.claude/CLAUDE.md
  "$RELINK" --apply
  conf <<'EOF'
shared  .claude
EOF
  run "$RELINK" --apply --force
  [ "$status" -eq 0 ]
  [ ! -L "$HOME/.claude" ]
  [ -d "$HOME/.claude" ]
  assert_link "$HOME/.claude/CLAUDE.md" "$DOTFILES_DIR/config/.claude/CLAUDE.md"
  [ -f "$DOTFILES_DIR/config/.claude/CLAUDE.md" ]
  [ ! -L "$DOTFILES_DIR/config/.claude/CLAUDE.md" ]
  [ "$(cat "$DOTFILES_DIR/config/.claude/CLAUDE.md")" = "x" ]
}

@test "shared directory whose destination root is a symlink outside the repo is drift, nothing written there" {
  track config/.claude/CLAUDE.md
  mkdir -p "${DOTFILES_DIR}-external"
  ln -sfn "${DOTFILES_DIR}-external" "$HOME/.claude"
  conf <<'EOF'
shared  .claude
EOF
  run "$RELINK" --apply
  [ "$status" -eq 1 ]
  [ ! -e "${DOTFILES_DIR}-external/CLAUDE.md" ]
}

@test "link directive creates an explicit link and does not replace the directory link" {
  track config/zsh/.zshrc
  track config/zsh/functions.zsh
  conf <<'EOF'
link  zsh/.zshrc  ~/.zshrc
EOF
  run "$RELINK" --apply
  [ "$status" -eq 0 ]
  assert_link "$HOME/.config/zsh" "$DOTFILES_DIR/config/zsh"
  assert_link "$HOME/.zshrc" "$DOTFILES_DIR/config/zsh/.zshrc"
}

@test "link directive can target a path under ~/.config" {
  track config/betterlockscreen/betterlockscreenrc
  conf <<'EOF'
link  betterlockscreen/betterlockscreenrc  ~/.config/betterlockscreenrc
EOF
  "$RELINK" --apply
  assert_link "$HOME/.config/betterlockscreenrc" \
    "$DOTFILES_DIR/config/betterlockscreen/betterlockscreenrc"
}

@test "link directive with missing destination exits 2" {
  track config/zsh/.zshrc
  conf <<'EOF'
link  zsh/.zshrc
EOF
  run "$RELINK"
  [ "$status" -eq 2 ]
}

@test "bare shared directive with no argument exits 2" {
  conf <<'EOF'
shared
EOF
  run "$RELINK"
  [ "$status" -eq 2 ]
}

# Put the fixture in the pre-migration state: the repo directory holds tracked
# files plus tool state, and the destination is a symlink pointing at it.
premigrate() {
  local name="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  ln -sfn "$DOTFILES_DIR/config/$name" "$dest"
}

@test "migration moves state out of the repo and links tracked files back in" {
  track config/.claude/CLAUDE.md "tracked content"
  track config/.claude/commands/gh/pr-create.md "nested tracked content"
  chmod 644 "$DOTFILES_DIR/config/.claude/commands/gh/pr-create.md"
  mkdir -p "$DOTFILES_DIR/config/.claude/sessions"
  printf 'session\n' > "$DOTFILES_DIR/config/.claude/sessions/a.jsonl"
  printf 'nested state\n' > "$DOTFILES_DIR/config/.claude/commands/gh/cache.json"
  conf <<'EOF'
shared  .claude
EOF
  premigrate .claude "$HOME/.claude"

  run "$RELINK" --apply
  [ "$status" -eq 0 ]

  [ ! -L "$HOME/.claude" ]
  [ -d "$HOME/.claude" ]
  [ "$(cat "$HOME/.claude/sessions/a.jsonl")" = "session" ]
  [ ! -e "$DOTFILES_DIR/config/.claude/sessions" ]
  assert_link "$HOME/.claude/CLAUDE.md" "$DOTFILES_DIR/config/.claude/CLAUDE.md"
  [ "$(cat "$DOTFILES_DIR/config/.claude/CLAUDE.md")" = "tracked content" ]

  # Nested tracked file: copied back into the repo as a real file with mode
  # and content intact, then linked back out.
  assert_link "$HOME/.claude/commands/gh/pr-create.md" \
    "$DOTFILES_DIR/config/.claude/commands/gh/pr-create.md"
  [ -f "$DOTFILES_DIR/config/.claude/commands/gh/pr-create.md" ]
  [ ! -L "$DOTFILES_DIR/config/.claude/commands/gh/pr-create.md" ]
  [ "$(cat "$DOTFILES_DIR/config/.claude/commands/gh/pr-create.md")" = "nested tracked content" ]
  [ "$(stat -f '%Lp' "$DOTFILES_DIR/config/.claude/commands/gh/pr-create.md")" = "644" ]

  # Nested untracked state under the same subdirectory: moved to the
  # destination, absent from the repo.
  [ "$(cat "$HOME/.claude/commands/gh/cache.json")" = "nested state" ]
  [ ! -e "$DOTFILES_DIR/config/.claude/commands/gh/cache.json" ]
}

@test "migration preserves untracked destination content byte-for-byte" {
  track config/.claude/CLAUDE.md
  mkdir -p "$DOTFILES_DIR/config/.claude/blabla"
  head -c 4096 /dev/urandom > "$DOTFILES_DIR/config/.claude/blabla/x.bin"
  local before; before="$(shasum "$DOTFILES_DIR/config/.claude/blabla/x.bin" | cut -d' ' -f1)"
  conf <<'EOF'
shared  .claude
EOF
  premigrate .claude "$HOME/.claude"

  "$RELINK" --apply

  local after; after="$(shasum "$HOME/.claude/blabla/x.bin" | cut -d' ' -f1)"
  [ "$before" = "$after" ]
}

@test "migration preserves uncommitted edits to tracked files" {
  track config/.claude/CLAUDE.md "committed"
  git -C "$DOTFILES_DIR" commit -qm init
  printf 'edited\n' > "$DOTFILES_DIR/config/.claude/CLAUDE.md"
  conf <<'EOF'
shared  .claude
EOF
  premigrate .claude "$HOME/.claude"

  "$RELINK" --apply

  [ "$(cat "$DOTFILES_DIR/config/.claude/CLAUDE.md")" = "edited" ]
}

@test "migration preserves mode bits" {
  track config/.claude/statusline.sh
  chmod 755 "$DOTFILES_DIR/config/.claude/statusline.sh"
  track config/.claude/mcp.json
  chmod 600 "$DOTFILES_DIR/config/.claude/mcp.json"
  conf <<'EOF'
shared  .claude
EOF
  premigrate .claude "$HOME/.claude"

  "$RELINK" --apply

  [ -x "$DOTFILES_DIR/config/.claude/statusline.sh" ]
  [ "$(stat -f '%Lp' "$DOTFILES_DIR/config/.claude/mcp.json")" = "600" ]
}

@test "a destination that is already a real directory is left alone" {
  track config/.claude/CLAUDE.md
  mkdir -p "$HOME/.claude/sessions"
  printf 'session\n' > "$HOME/.claude/sessions/a.jsonl"
  conf <<'EOF'
shared  .claude
EOF
  "$RELINK" --apply
  [ "$(cat "$HOME/.claude/sessions/a.jsonl")" = "session" ]
  assert_link "$HOME/.claude/CLAUDE.md" "$DOTFILES_DIR/config/.claude/CLAUDE.md"
}

@test "a missing destination is created fresh without migrating" {
  track config/.claude/CLAUDE.md
  conf <<'EOF'
shared  .claude
EOF
  "$RELINK" --apply
  [ -d "$HOME/.claude" ]
  assert_link "$HOME/.claude/CLAUDE.md" "$DOTFILES_DIR/config/.claude/CLAUDE.md"
}

@test "dry run does not migrate" {
  track config/.claude/CLAUDE.md
  conf <<'EOF'
shared  .claude
EOF
  premigrate .claude "$HOME/.claude"
  run "$RELINK"
  [ "$status" -eq 1 ]
  [ -L "$HOME/.claude" ]
}

@test "dry run over a repo-symlinked root previews the migration and its links without reporting drift" {
  track config/.claude/CLAUDE.md
  conf <<'EOF'
shared  .claude
EOF
  premigrate .claude "$HOME/.claude"

  run "$RELINK"
  [ "$status" -eq 1 ]
  [[ "$output" == *"migrate  config/.claude"* ]]
  [[ "$output" == *"link     "*"CLAUDE.md"* ]]
  [[ "$output" != *"  drift    "* ]]
  [[ "$output" != *"  prune    "*"/.claude"* ]]
  [ -L "$HOME/.claude" ]
}

# A submodule (gitlink) index entry has no blob content to cp -p; it is a
# real directory on disk. It must be skipped, not abort the whole migration.
@test "migration skips a gitlink entry instead of aborting, and the rest of the tracked files land" {
  track config/.claude/CLAUDE.md
  mkdir -p "$DOTFILES_DIR/config/.claude/sub"
  touch "$DOTFILES_DIR/config/.claude/sub/.keep"
  git -C "$DOTFILES_DIR" update-index --add --cacheinfo \
    160000,e69de29bb2d1d6434b8b29ae775ad8c2e48c5391,config/.claude/sub
  conf <<'EOF'
shared  .claude
EOF
  premigrate .claude "$HOME/.claude"

  run "$RELINK" --apply
  [ "$status" -eq 1 ]

  [ ! -L "$HOME/.claude" ]
  [ -d "$HOME/.claude" ]
  assert_link "$HOME/.claude/CLAUDE.md" "$DOTFILES_DIR/config/.claude/CLAUDE.md"
  [ "$(cat "$DOTFILES_DIR/config/.claude/CLAUDE.md")" = "x" ]
  [ -d "$HOME/.claude/sub" ]
  [ "$(cat "$HOME/.claude/sub/.keep" 2>/dev/null; echo ok)" = "ok" ]
  [[ "$output" == *"warn"*"config/.claude/sub is not a regular file; skipped"* ]]
}

@test "-q does not silence the tracked-but-missing warning" {
  track config/.claude/CLAUDE.md
  track config/.claude/GONE.md
  rm "$DOTFILES_DIR/config/.claude/GONE.md"
  conf <<'EOF'
shared  .claude
EOF
  premigrate .claude "$HOME/.claude"

  run "$RELINK" --apply -q
  [[ "$output" == *"warn"*"GONE.md is tracked but missing"* ]]
}

@test "a link to a file no longer tracked is pruned" {
  track config/.claude/CLAUDE.md
  track config/.claude/old.md
  conf <<'EOF'
shared  .claude
EOF
  "$RELINK" --apply
  assert_link "$HOME/.claude/old.md" "$DOTFILES_DIR/config/.claude/old.md"

  git -C "$DOTFILES_DIR" rm -q --cached config/.claude/old.md
  rm "$DOTFILES_DIR/config/.claude/old.md"

  "$RELINK" --apply
  [ ! -L "$HOME/.claude/old.md" ]
  assert_link "$HOME/.claude/CLAUDE.md" "$DOTFILES_DIR/config/.claude/CLAUDE.md"
}

@test "prune never removes untracked content at the destination" {
  track config/.claude/CLAUDE.md
  conf <<'EOF'
shared  .claude
EOF
  "$RELINK" --apply
  mkdir -p "$HOME/.claude/blabla"
  printf 'state\n' > "$HOME/.claude/blabla/x.json"
  printf 'top\n' > "$HOME/.claude/history.jsonl"
  ln -sfn /tmp "$HOME/.claude/elsewhere"

  "$RELINK" --apply

  [ "$(cat "$HOME/.claude/blabla/x.json")" = "state" ]
  [ "$(cat "$HOME/.claude/history.jsonl")" = "top" ]
  [ -L "$HOME/.claude/elsewhere" ]
}

@test "a stale repo-pointing link at \$HOME top level is pruned" {
  track config/nvim/init.lua
  ln -sfn "$DOTFILES_DIR/config/gone/thing.conf" "$HOME/.oldrc"
  "$RELINK" --apply
  [ ! -L "$HOME/.oldrc" ]
}

@test "a link pointing outside the repo at \$HOME top level survives" {
  track config/nvim/init.lua
  ln -sfn /tmp "$HOME/.elsewhere"
  "$RELINK" --apply
  [ -L "$HOME/.elsewhere" ]
}

@test "a link to a prefix-colliding sibling directory survives prune" {
  track config/nvim/init.lua
  mkdir -p "${DOTFILES_DIR}-old/x"
  touch "${DOTFILES_DIR}-old/x/thing.conf"
  ln -sfn "${DOTFILES_DIR}-old/x" "$HOME/.sib"
  "$RELINK" --apply
  [ -L "$HOME/.sib" ]
}

@test "a link that lexically walks out of the repo via .. survives prune" {
  track config/nvim/init.lua
  mkdir -p "$(dirname "$DOTFILES_DIR")/outside"
  printf 'secret\n' > "$(dirname "$DOTFILES_DIR")/outside/secret"
  ln -sfn "$DOTFILES_DIR/../outside/secret" "$HOME/.escape"
  "$RELINK" --apply
  [ -L "$HOME/.escape" ]
}

@test "a regular file at a planned link site is reported and not clobbered" {
  track config/.claude/settings.json "repo version"
  conf <<'EOF'
shared  .claude
EOF
  mkdir -p "$HOME/.claude"
  printf 'tool version\n' > "$HOME/.claude/settings.json"

  run "$RELINK" --apply
  [ "$status" -eq 1 ]
  [ "$(cat "$HOME/.claude/settings.json")" = "tool version" ]
  echo "$output" | grep -q drift
}

@test "--force replaces a regular file at a planned link site" {
  track config/.claude/settings.json "repo version"
  conf <<'EOF'
shared  .claude
EOF
  mkdir -p "$HOME/.claude"
  printf 'tool version\n' > "$HOME/.claude/settings.json"

  run "$RELINK" --apply --force
  [ "$status" -eq 0 ]
  assert_link "$HOME/.claude/settings.json" "$DOTFILES_DIR/config/.claude/settings.json"
  [ "$(cat "$HOME/.claude/settings.json")" = "repo version" ]
}

# Regression test for the worst behaviour in the tool: if a `shared` line in
# links.conf is ever lost (bad merge, stale checkout, typo), the plan reverts
# to a whole-directory link and $HOME/.claude — a real directory that may hold
# hundreds of megabytes of session state and credentials — becomes "drift".
# --force must never rm -rf that directory to make room for a symlink.
@test "--force refuses to replace a real directory at a planned link site; contents survive" {
  track config/.claude/CLAUDE.md
  mkdir -p "$HOME/.claude/sessions"
  printf 'irreplaceable state\n' > "$HOME/.claude/sessions/a.jsonl"

  run "$RELINK" --apply --force
  [ "$status" -eq 1 ]
  [ -d "$HOME/.claude" ]
  [ ! -L "$HOME/.claude" ]
  [ -d "$HOME/.claude/sessions" ]
  [ "$(cat "$HOME/.claude/sessions/a.jsonl")" = "irreplaceable state" ]
  [[ "$output" == *"drift"*"real directory"* ]]
  [[ "$output" != *"force"* ]]
}

@test "--force refuses to replace when the planned source is missing; file survives" {
  conf <<'EOF'
link  zsh/.zshrc  ~/.zshrc
EOF
  printf 'existing content\n' > "$HOME/.zshrc"

  run "$RELINK" --apply --force
  [ "$status" -eq 1 ]
  [ ! -L "$HOME/.zshrc" ]
  [ "$(cat "$HOME/.zshrc")" = "existing content" ]
  [[ "$output" != *"force"* ]]
}

@test "-q suppresses output but keeps the exit code" {
  track config/nvim/init.lua
  run "$RELINK" -q
  [ "$status" -eq 1 ]
  [ -z "$output" ]
}

@test "symlink at a planned link site whose target absolutely escapes the repo via .. is drift, not silently fixed" {
  track config/nvim/init.lua
  mkdir -p "$(dirname "$DOTFILES_DIR")/outside"
  printf 'secret\n' > "$(dirname "$DOTFILES_DIR")/outside/secret"
  mkdir -p "$HOME/.config"
  ln -sfn "$DOTFILES_DIR/../outside/secret" "$HOME/.config/nvim"

  run "$RELINK" --apply
  [ "$status" -eq 1 ]
  assert_link "$HOME/.config/nvim" "$DOTFILES_DIR/../outside/secret"
}

@test "symlink at a planned link site whose target absolutely escapes the repo via .. is fixed by --apply --force" {
  track config/nvim/init.lua
  mkdir -p "$(dirname "$DOTFILES_DIR")/outside"
  printf 'secret\n' > "$(dirname "$DOTFILES_DIR")/outside/secret"
  mkdir -p "$HOME/.config"
  ln -sfn "$DOTFILES_DIR/../outside/secret" "$HOME/.config/nvim"

  run "$RELINK" --apply --force
  [ "$status" -eq 0 ]
  assert_link "$HOME/.config/nvim" "$DOTFILES_DIR/config/nvim"
}

@test "symlink at a planned link site whose relative target resolves inside the repo at the wrong file is silently fixed by --apply" {
  track config/nvim/init.lua
  track config/old-nvim/init.lua
  mkdir -p "$HOME/.config"
  ln -sfn "../../dotfiles/config/old-nvim/init.lua" "$HOME/.config/nvim"

  run "$RELINK" --apply
  [ "$status" -eq 0 ]
  assert_link "$HOME/.config/nvim" "$DOTFILES_DIR/config/nvim"
}
