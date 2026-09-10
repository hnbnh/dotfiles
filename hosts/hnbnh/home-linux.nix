# home-manager, standalone on Fedora.
{ username, ... }:

let
  # Fedora only.
  caBundle = "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem";
in
{
  imports = [
    ./home.nix
    ../../modules/cli/linux.nix
    ../../modules/desktop
    ../../modules/fonts/linux.nix
    ../../modules/gui/linux.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  targets.genericLinux.enable = true;
  targets.genericLinux.gpu.enable = false;

  home.sessionVariables = {
    SSL_CERT_FILE = caBundle;
    GIT_SSL_CAINFO = caBundle;
  };
}
