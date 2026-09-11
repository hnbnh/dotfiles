# nix-darwin on Darwin, system-manager on Linux.
{ lib, pkgs, platform, ... }:

{
  imports =
    lib.optional platform.isDarwin ./darwin.nix
    ++ lib.optional platform.isLinux ./linux.nix;

  environment.systemPackages = with pkgs; [
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
    imagemagick
    jaq
    jq
    lazydocker
    lazygit
    mise
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
