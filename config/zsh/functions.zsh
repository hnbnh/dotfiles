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
