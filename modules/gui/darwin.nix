# nix-darwin.
{ ... }:

{
  homebrew.brews = [
    "mpv" # a video player, so GUI; the other brews are in modules/cli/darwin.nix
  ];

  homebrew.casks = [
    "bruno"
    "firefox"
    "ghostty"
    "gonhanh"
    "keka"
    "notion"
    "orbstack"
    "steam"
    "telegram-desktop"
    "tor-browser"
    "utm"
    "visual-studio-code"
    "wezterm"
    "zen"
  ];
}
