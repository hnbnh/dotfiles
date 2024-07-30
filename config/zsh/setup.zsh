export XDG_CONFIG_HOME=~/.config

# Nix
export PATH="/run/current-system/sw/bin:$PATH"
if [ -e /home/hnbnh/.nix-profile/etc/profile.d/nix.sh ]; then source /home/hnbnh/.nix-profile/etc/profile.d/nix.sh; fi

# mise
eval "$(~/.local/bin/mise activate zsh)"

# starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# ripgrep
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/.ripgreprc

# nnn
export NNN_PLUG='f:fzcd;p:preview-tui;g:diffs;t:nmount;z:autojump;d:dragdrop'
export NNN_FIFO=/tmp/nnn.fifo
export PAGER="less -Ri"
export ICONLOOKUP=1
BLK="03" CHR="03" DIR="04" EXE="02" REG="07" HARDLINK="05" SYMLINK="05" MISSING="08" ORPHAN="01" FIFO="06" SOCK="03" UNKNOWN="01"
export NNN_COLORS="#04020301;4231"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$UNKNOWN"

# fzf
[ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh

# vi mode
# Ctrl-f is not functioning after switching to vi mode, unsure of the reason
bindkey '^f' autosuggest-accept
