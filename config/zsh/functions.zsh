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

