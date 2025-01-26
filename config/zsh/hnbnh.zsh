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

eval "$(mise activate zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)

autoload -U compinit
compinit
