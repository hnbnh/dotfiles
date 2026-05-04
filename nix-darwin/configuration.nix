{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep curl
  environment.systemPackages = with pkgs; [
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
    fzf
    gh
    git
    gnupg
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

  environment.systemPath = [
    config.homebrew.prefix
  ];

  fonts = {
    packages = [
      pkgs.nerd-fonts.meslo-lg
      pkgs.nerd-fonts.geist-mono
    ];
  };

  # Homebrew packages
  homebrew = {
    enable = true;
    taps = [
    ];

    brews = [
      "gemini-cli"
      "libyaml"
      "mise"
      "mole"
      "mpv"
      "sqlite3"
    ];
    casks = [
      "brave-browser"
      "datagrip"
      "firefox"
      "ghostty"
      "gonhanh"
      "karabiner-elements"
      "keka"
      "orbstack"
      "steam"
      "telegram-desktop"
      "tor-browser"
      "utm"
      "visual-studio-code"
      "wezterm"
      "zen-browser"
    ];
  };

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
    };
    controlcenter = {
      BatteryShowPercentage = true;
      Sound = true;
    };
    finder = {
      ShowPathbar = true;
    };
    trackpad = {
      # tap to click
      Clicking = true;
    };
    universalaccess = {
      reduceMotion = true;
      reduceTransparency = true;
    };
    # TODO: https://github.com/LnL7/nix-darwin/issues/1046
    # Turn on night shift
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
      GloballyEnabled = false;
      AppWindowGroupingBehavior = false;
    };
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  system.primaryUser = "hnbnh";
}
