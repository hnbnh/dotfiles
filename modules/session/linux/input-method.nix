{ pkgs, ... }:

{
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
}
