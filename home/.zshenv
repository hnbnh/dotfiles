export XDG_CONFIG_HOME=~/.config
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/.ripgreprc
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
export EDITOR=vim

for hm_vars in "$HOME/.nix-profile" "/etc/profiles/per-user/$USER"; do
  if [ -f "$hm_vars/etc/profile.d/hm-session-vars.sh" ]; then
    . "$hm_vars/etc/profile.d/hm-session-vars.sh"
  fi
done
