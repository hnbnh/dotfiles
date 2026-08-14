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

@test "shared directory whose destination root is a repo symlink is drift, not destroyed" {
  track config/.claude/CLAUDE.md
  "$RELINK" --apply
  conf <<'EOF'
shared  .claude
EOF
  run "$RELINK" --apply
  [ "$status" -eq 1 ]
  [ -f "$DOTFILES_DIR/config/.claude/CLAUDE.md" ]
  [ ! -L "$DOTFILES_DIR/config/.claude/CLAUDE.md" ]
  [ "$(cat "$DOTFILES_DIR/config/.claude/CLAUDE.md")" = "x" ]
}

@test "shared directory whose destination root is a repo symlink survives --apply --force" {
  track config/.claude/CLAUDE.md
  "$RELINK" --apply
  conf <<'EOF'
shared  .claude
EOF
  run "$RELINK" --apply --force
  [ "$status" -eq 1 ]
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
