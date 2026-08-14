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
  mkdir -p "$DOTFILES_DIR/config/.claude/sessions"
  printf 'session\n' > "$DOTFILES_DIR/config/.claude/sessions/a.jsonl"
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
