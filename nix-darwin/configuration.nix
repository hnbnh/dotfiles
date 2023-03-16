{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep curl
  environment.systemPackages = with pkgs; [
    aria
    bat
    curl
    dbeaver
    delta
    diskonaut
    docker
    fd
    fnm
    fzf
    gh
    git
    glow
    gnupg
    go
    hyperfine
    jq
    kdash
    kitty
    lazydocker
    lazygit
    micromamba
    neovim
    nnn
    nodePackages.pnpm
    nodePackages.yarn
    ripgrep
    rustup
    slack
    so
    starship
    tealdeer
    tor
    tree
    unzip
    w3m
    watch
    yt-dlp
    zoxide
  ];

  environment.systemPath = [
    config.homebrew.brewPrefix # TODO https://github.com/LnL7/nix-darwin/issues/596
  ];

  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override {
        fonts = [
          "DejaVuSansMono"
          "FiraCode"
          "JetBrainsMono"
          "VictorMono"
        ];
      })
    ];
  };

  # Homebrew packages
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [
      { name = "homebrew/cask"; }
    ];
    brews = [
      "mpv"
    ];
    casks = [
      "brave-browser"
      "flameshot"
      "insomnia"
      "karabiner-elements"
      "notion-enhanced"
      "obs"
      "visual-studio-code"
      "wine-stable"
    ];
  };

  system.defaults = {
    alf = {
      globalstate = 1;
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [
        "@admin"
      ];
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.hnbnh = { pkgs, lib, ... }: {
      home.stateVersion = "22.11";
      programs.home-manager.enable = true;
    };
  };
}
