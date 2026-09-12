{
  system = {
    imports = [
      ../modules/gui
      ../modules/keyboard
    ];
  };

  home =
    let
      caBundle = "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem";
    in
    {
      imports = [ ../modules/session ];

      targets.genericLinux.enable = true;
      targets.genericLinux.gpu.enable = false;

      home.sessionPath = [ "/run/system-manager/sw/bin" ];
      xdg.systemDirs.data = [ "/run/system-manager/sw/share" ];

      home.sessionVariables = {
        SSL_CERT_FILE = caBundle;
        GIT_SSL_CAINFO = caBundle;
      };
    };
}
