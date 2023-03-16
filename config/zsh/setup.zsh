# starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# fnm
export PATH="$HOME/.fnm:$PATH"
fpath=(~/.zsh $fpath)
eval "`fnm env`"

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

# mamba
export MAMBA_EXE="$HOME/.local/bin/micromamba";
export MAMBA_ROOT_PREFIX="$HOME/micromamba";
__mamba_setup="$($MAMBA_EXE shell hook --shell bash --prefix $MAMBA_ROOT_PREFIX 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    if [ -f "$HOME/micromamba/etc/profile.d/micromamba.sh" ]; then
        . "$HOME/micromamba/etc/profile.d/micromamba.sh"
    else
        export  PATH="$HOME/micromamba/bin:$PATH"  # extra space after export prevents interference from conda init
    fi
fi
unset __mamba_setup

# Nix
export PATH="/run/current-system/sw/bin:$PATH"

# vi mode
# Ctrl-f is not functioning after switching to vi mode, unsure of the reason
bindkey '^f' autosuggest-accept
