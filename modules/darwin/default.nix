{ config, lib, pkgs, ... }:

{
  imports = [
    ./system-defaults.nix
    ./homebrew.nix
    ./fonts.nix
  ];

  # mkOrder 1100 places our packages after nix-darwin's own default
  # contributions (zsh, bash, nix, docs; all unwrapped, order 1000), which is
  # where an unwrapped definition happened to land in the old flat
  # configuration.nix. Unwrapped, this ties at order 1000 with those
  # contributions and the winner depends on import-graph depth — under this
  # module layout that tie is not guaranteed to reproduce the old order.
  # This has no effect on the realized environment (buildEnv output is
  # order-independent); it only pins the merge order deterministically so the
  # built derivation matches the pre-refactor one.
  environment.systemPackages = lib.mkOrder 1100 (with pkgs; [
    aria2
    bat
    btop
    curl
    delta
    docker
    eza
    fastfetch
    fd
    ffmpeg
    fx
    fzf
    gallery-dl
    gh
    git
    gnupg
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
  ]);

  # mkOrder 1100 places Homebrew after the Nix profiles (order 1000) and
  # before nix-darwin's own /usr/local/bin:/usr/bin:... group (mkOrder 1200),
  # which is where an unwrapped definition happened to land in the old flat
  # configuration.nix. Unwrapped, this ties at order 1000 with nix-darwin's
  # profile paths and the winner depends on import-graph depth — under this
  # module layout that tie flips and Homebrew shadows Nix system-wide.
  environment.systemPath = lib.mkOrder 1100 [
    config.homebrew.prefix
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
