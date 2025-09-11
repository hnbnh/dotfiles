{ pkgs }:

with pkgs;
let
  lib = pkgs.lib;
  commonPackages = [
    aria
    bat
    btop
    calibre
    colima
    curl
    delta
    docker
    fastfetch
    fd
    ffmpeg
    fzf
    gh
    git
    gnupg
    imagemagick
    jq
    lazydocker
    lazygit
    mise
    mkcert
    mpv
    neovim
    nixfmt
    oh-my-posh
    ripgrep
    sesh
    starship
    tmux
    yazi
    yq-go
    yt-dlp
    zellij
    zoxide
  ];

  darwinOnlyPackages = [
  ];

  linuxOnlyPackages = [
    cliphist
    hyprpanel
    hyprpaper
    hyprsunset
    tofi
    wob
    xremap
  ];
in
commonPackages
++ lib.optionals pkgs.stdenv.isDarwin darwinOnlyPackages
++ lib.optionals pkgs.stdenv.isLinux linuxOnlyPackages
