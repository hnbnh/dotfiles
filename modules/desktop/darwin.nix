{ ... }:

{
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
}
