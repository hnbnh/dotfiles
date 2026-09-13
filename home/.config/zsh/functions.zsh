source ~/.config/bash/functions
source ~/.config/bash/gh

function nn() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function mkfile() {
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

      # nixpkgs' zsh-syntax-highlighting ships no .plugin.zsh shim
      for plugin_file in "$plugin_dir$plugin_name".{plugin.zsh,zsh}; do
        if [[ -f "$plugin_file" ]]; then
          source "$plugin_file"
          break
        fi
      done
    fi
  done
}
