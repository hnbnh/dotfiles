# home-manager, standalone on Fedora.
{ ... }:

let
  # Fedora only.
  caBundle = "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem";
in
{
  imports = [
    ../../modules/cli/linux.nix
    ../../modules/desktop/linux
    ../../modules/fonts/linux.nix
    ../../modules/gui/linux.nix
  ];

  targets.genericLinux.enable = true;
  targets.genericLinux.gpu.enable = false;

  home.sessionVariables = {
    SSL_CERT_FILE = caBundle;
    GIT_SSL_CAINFO = caBundle;
  };
}
