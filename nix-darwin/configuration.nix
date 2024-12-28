{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep curl
  environment.systemPackages = with pkgs; [
    aria
    bat
    curl
    delta
    fastfetch
    fd
    fzf
    gh
    git
    gnupg
    jq
    lazydocker
    lazygit
    mise
    neovim
    ripgrep
    sqlite
    starship
    yazi
    yt-dlp
    zoxide
  ];

  environment.systemPath = [
    config.homebrew.brewPrefix # TODO https://github.com/LnL7/nix-darwin/issues/596
  ];

  fonts = {
    packages = [
      pkgs.nerd-fonts.meslo-lg
    ];
  };

  # Homebrew packages
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [
    ];

    brews = [
      "libyaml"
    ];
    casks = [
      "brave-browser"
      "datagrip"
      "docker"
      "firefox"
      "karabiner-elements"
      "rectangle"
      "steam"
      "telegram"
      "tor-browser"
      "utm"
      "visual-studio-code"
      "wezterm"
      "zen-browser"
      "zoom"
    ];
  };

  system.defaults = {
    alf = {
      globalstate = 1;
    };
    dock = {
      autohide = true;
      mru-spaces = false;
    };
    trackpad = {
      # tap to click
      Clicking = true;
    };
    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };
    WindowManager = {
      GloballyEnabled = true;
      AppWindowGroupingBehavior = false;
    };
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
