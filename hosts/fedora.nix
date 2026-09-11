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

      home.sessionVariables = {
        SSL_CERT_FILE = caBundle;
        GIT_SSL_CAINFO = caBundle;
      };
    };
}
