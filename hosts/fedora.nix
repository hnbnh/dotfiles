# Fedora: system-manager for the machine, standalone home-manager for the user.
{
  # system-manager.
  system = {
    imports = [
      ../modules/gui
      ../modules/keyboard
    ];
  };

  # home-manager, standalone.
  home =
    let
      caBundle = "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem";
    in
    {
      imports = [ ../modules/session ];

      targets.genericLinux.enable = true;
      targets.genericLinux.gpu.enable = false;

      # Packages live in system-manager's profile. Its profile.d script only
      # reaches login shells, so also put the profile on PATH through
      # hm-session-vars.sh (every zsh sources it from .zshenv) and on
      # XDG_DATA_DIRS in the systemd user environment.
      home.sessionPath = [ "/run/system-manager/sw/bin" ];
      xdg.systemDirs.data = [ "/run/system-manager/sw/share" ];

      home.sessionVariables = {
        SSL_CERT_FILE = caBundle;
        GIT_SSL_CAINFO = caBundle;
      };
    };
}
