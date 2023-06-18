export XDG_CONFIG_HOME=~/.config

# Nix
export PATH="/run/current-system/sw/bin:$PATH"

# rtx
eval "$(rtx activate zsh)"

# starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# nnn
export NNN_PLUG='f:fzcd;p:preview-tui;g:diffs;t:nmount;z:autojump;d:dragdrop'
export NNN_FIFO=/tmp/nnn.fifo
export PAGER="less -Ri"
export ICONLOOKUP=1
BLK="04" CHR="04" DIR="04" EXE="00" REG="00" HARDLINK="00" SYMLINK="06" MISSING="00" ORPHAN="01" FIFO="0F" SOCK="0F" OTHER="02"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# rust
. "$HOME/.cargo/env"

# go
export PATH=$PATH:$HOME/.go/bin
export PATH=$PATH:$HOME/go/bin

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# vi mode
# Ctrl-f is not functioning after switching to vi mode, unsure of the reason
bindkey '^f' autosuggest-accept
