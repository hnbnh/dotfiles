ZSH_DIR="$HOME/.config/zsh"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

setopt autocd
setopt autopushd
setopt sharehistory
setopt histignorealldups
setopt histexpiredupsfirst
setopt histignoredups
setopt histignorespace

load_plugins

bindkey -v
bindkey '^F' autosuggest-accept
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history

eval "$(mise activate zsh)"
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/hnbnh.toml)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)

autoload -U compinit
compinit
