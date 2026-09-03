{ pkgs, ... }:

let
  # Fedora only.
  caBundle = "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem";
in
{
  imports = [
    ./user.nix
    ./packages/linux.nix
    ./noctalia.nix
    ./wallpaper.nix
  ];

  home.username = "hnbnh";
  home.homeDirectory = "/home/hnbnh";

  targets.genericLinux.enable = true;
  targets.genericLinux.gpu.enable = false;

  fonts.fontconfig.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs.qt6Packages; [
        fcitx5-unikey
        fcitx5-configtool
      ];
      waylandFrontend = true;
      settings = {
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "unikey";
        };
        addons.unikey.globalSection = {
          InputMethod = "Telex";
          OutputCharset = "Unicode";
        };
      };
    };
  };

  home.sessionVariables = {
    SSL_CERT_FILE = caBundle;
    GIT_SSL_CAINFO = caBundle;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.common.default = [
      "gnome"
      "gtk"
    ];
  };
}
