{ pkgs, ... }:

{
  home.packages = with pkgs; [
    aria2
    bat
    btop
    curl
    delta
    eza
    fastfetch
    fd
    ffmpeg
    fx
    fzf
    gallery-dl
    gh
    git
    herdr
    jaq
    jq
    lazydocker
    lazygit
    mkcert
    neovim
    nixfmt
    ripgrep
    sesh
    starship
    tmux
    witr
    yazi
    yq-go
    yt-dlp
    zellij
    zoxide
  ];
}
