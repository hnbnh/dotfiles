ZSH_DIR="$HOME/.config/zsh"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

HISTFILE="$HOME/.zsh_history"
HISTSIZE=500000
SAVEHIST=500000

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
export DOCKER_HOST=$(docker context inspect colima | jq -r '.[0].Endpoints.docker.Host')

autoload -U compinit
compinit
