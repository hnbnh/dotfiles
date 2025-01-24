function nn() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

mkfile() {
  mkdir -p "$(dirname "$1")" && touch "$1"
}

function zvm_after_init() {
  zvm_bindkey viins "^R" fzf-history-widget
}

function load_plugins() {
  local dir="$ZSH_DIR/plugins"

  if [[ ! -d "$dir" ]]; then
    echo "No plugins found in $dir"
    return
  fi

  for plugin_dir in "$dir"/*/; do
    if [[ -d "$plugin_dir" ]]; then
      local plugin_name=$(basename "$plugin_dir")
      local plugin_file="$plugin_dir$plugin_name.plugin.zsh"

      if [[ -f "$plugin_file" ]]; then
        source "$plugin_file"
      fi
    fi
  done
}

function clean_up() {
  nix-collect-garbage --delete-older-than 7d
  sudo nix-collect-garbage --delete-older-than 7d

  nix-collect-garbage -d
  sudo nix-collect-garbage -d
}

function have {
  command -v "$1" &>/dev/null
}

function install_dots {
  CFG_DIR="$HOME/dotfiles/config"
  DEST_DIR="$HOME/.config"

  mkdir -p $DEST_DIR

  for dir in "$CFG_DIR"/*/; do
    ln -sfnv $dir $DEST_DIR
  done

  ln -sfnv "$CFG_DIR/zsh/.zshrc" "$HOME/.zshrc"
  ln -sfnv "$CFG_DIR/zsh/.zshenv" "$HOME/.zshenv"
  ln -sfnv "$CFG_DIR/zsh/.zimrc" "$HOME/.zimrc"
  ln -sfnv "$CFG_DIR/git/.gitconfig" "$HOME/.gitconfig"
}

