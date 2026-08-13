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
