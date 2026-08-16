# Standalone home-manager on Fedora: everything the user needs, including the
# Hyprland desktop, comes from nixpkgs. Fedora itself only supplies the
# kernel, nix, and the login stack (see modules/system).
{ pkgs, ... }:

{
  imports = [
    ./user.nix
    ./packages/linux.nix
  ];

  home.username = "hnbnh";
  home.homeDirectory = "/home/hnbnh";

  # Non-NixOS host: fix XDG_DATA_DIRS for nix-installed .desktop files, and
  # build /run/opengl-driver so nix-built Wayland/GL programs (Hyprland,
  # wezterm, mpv, ...) can use the host GPU. The driver link needs root once
  # per mesa update; install.sh runs `non-nixos-gpu-setup`, and later
  # switches warn when it must be re-run.
  targets.genericLinux.enable = true;

  # Vietnamese input. home-manager has no ibus module, so this is what
  # NixOS's i18n.inputMethod would do: ibus with the engine baked in, plus
  # the IM variables. ibus-daemon itself is started from hyprland.conf.
  home.packages = [
    (pkgs.ibus-with-plugins.override { plugins = [ pkgs.ibus-engines.bamboo ]; })
  ];
  home.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
    GLFW_IM_MODULE = "ibus";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common.default = [
      "hyprland"
      "gtk"
    ];
  };

  # Fedora's nix.conf is the daemon's; flakes are opted into per user.
  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';
}
