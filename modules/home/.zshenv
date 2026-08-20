export XDG_CONFIG_HOME=~/.config
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/.ripgreprc
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
export EDITOR=vim

# Linux: standalone home-manager installs into ~/.nix-profile and nothing on a
# non-NixOS host sources its session variables. This runs for `zsh -c` too,
# which is how the display manager starts the niri session. On macOS
# nix-darwin handles both and these paths don't exist.
if [ -d "$HOME/.nix-profile/bin" ]; then
  export PATH="$HOME/.nix-profile/bin:$PATH"
fi
if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
