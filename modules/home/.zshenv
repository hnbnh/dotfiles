export XDG_CONFIG_HOME=~/.config
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/.ripgreprc
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
export EDITOR=vim

if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
