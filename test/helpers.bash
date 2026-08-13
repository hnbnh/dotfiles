# Fixture: a throwaway git repo standing in for ~/dotfiles, plus a throwaway $HOME.
# Every test gets its own; nothing touches the real home directory.

setup_fixture() {
  FIXTURE_ROOT="$(mktemp -d)"
  FIXTURE_ROOT="$(cd "$FIXTURE_ROOT" && pwd -P)"

  export HOME="$FIXTURE_ROOT/home"
  export DOTFILES_DIR="$FIXTURE_ROOT/dotfiles"
  export RELINK="$BATS_TEST_DIRNAME/../bin/relink"

  mkdir -p "$HOME/.config" "$DOTFILES_DIR/config"
  git -C "$DOTFILES_DIR" init -q
  git -C "$DOTFILES_DIR" config user.email test@example.com
  git -C "$DOTFILES_DIR" config user.name test
}

teardown_fixture() {
  [ -n "${FIXTURE_ROOT:-}" ] && rm -rf "$FIXTURE_ROOT"
  return 0
}

# Create a tracked file in the fixture repo. Path is relative to the repo root.
# git ls-files reads the index, so staging is enough — no commit needed.
track() {
  local path="$1" content="${2:-x}"
  mkdir -p "$DOTFILES_DIR/$(dirname "$path")"
  printf '%s\n' "$content" > "$DOTFILES_DIR/$path"
  git -C "$DOTFILES_DIR" add -f "$path"
}

# Write config/links.conf from stdin.
conf() {
  cat > "$DOTFILES_DIR/config/links.conf"
}

# Assert $1 is a symlink resolving to $2.
assert_link() {
  [ -L "$1" ] || { echo "not a symlink: $1"; return 1; }
  local actual; actual="$(readlink "$1")"; actual="${actual%/}"
  [ "$actual" = "$2" ] || { echo "link $1 -> $actual, expected $2"; return 1; }
}
